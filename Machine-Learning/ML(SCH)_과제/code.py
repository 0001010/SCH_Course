import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split, KFold
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import cross_val_score
from sklearn.neural_network import MLPRegressor
import pickle


"""

(0) Problem
입력은 train데이터 있는 Purchase변수를 제외한 모든변수이고 출력은 train데이터에 있는 Purchase변수입니다.
Purchase변수는 Numeric 타입이므로 회귀이고 그래프와 qqplot으로 확인해본 결과 비선형을 띄고 있는 것을 확인 했습니다.

"""

train = pd.read_csv('/home/u1033/homework8/train.csv')

"""

(1) Feature
1. 결측값이 있었고 데이터를 살펴본 결과 변수 Product_Category_1, Product_Category_2, Product_Category_3이 이어져있다는 것을 확인했습니다. 
그래서 drop 하지않고 결측값을 -1로 채웠습니다.
2. 변수 Age는 순서로 이루어져있는 변수여서 나이 순서로 labeling을 진행했고 변수 Gender는 label이 2개라서 0,1로 labeling했습니다.
3. Product_ID를 drop할 예정이지만 Product_ID의 정보를 주기 위해서 각 Product_ID별로 count를 해서 변수로 만들었습니다. 
카테고리 변수들은 one-hot인코딩을 진행했고 예측에 필요없는 정보라고 생각되는 변수들은 drop했습니다.

"""

train_new = train.fillna(-1)
train_new.loc[(train_new['Age']=='0-17'),'Age'] = 1
train_new.loc[(train_new['Age']=='18-25'),'Age'] = 2
train_new.loc[(train_new['Age']=='26-35'),'Age'] = 3
train_new.loc[(train_new['Age']=='36-45'),'Age'] = 4
train_new.loc[(train_new['Age']=='46-50'),'Age'] = 5
train_new.loc[(train_new['Age']=='51-55'),'Age'] = 6
train_new.loc[(train_new['Age']=='55+'),'Age'] = 7

train_new.loc[(train_new['Gender']=='F'),'Gender'] = 0
train_new.loc[(train_new['Gender']=='M'),'Gender'] = 1

Product_count = train_new['Product_ID'].value_counts().to_frame().reset_index().rename(columns = {
    'index' : 'Product_ID', 'Product_ID' : 'count'
})

train_new = pd.merge(train_new, Product_count, on = 'Product_ID')

cat_columns = ['Occupation', 'City_Category', 'Marital_Status', 'Product_Category_1', 'Product_Category_2']

def col_type(columns, type):
    for i in columns:
        train_new[i] = train_new[i].astype(type)

col_type(cat_columns, 'category')

train_new2 = pd.get_dummies(train_new,columns = cat_columns)
train_new2.drop(['User_ID', 'Product_ID', 'Product_Category_3', 'Stay_In_Current_City_Years'], axis = 1, inplace = True)

fold = KFold(n_splits = 10, shuffle = True, random_state = 123456)

fold_idx = 1
columns = train_new2.columns.to_list()
del columns[2]
"""

(2) Model 
저는 MLP Regression 모델을 사용했습니다. 기 학습한 모델을 pickle로 불러와서 진행했습니다.
데이터가 비선형을 띄고있어서 linear, lasso, ridge는 맞지않을거라고 생각했습니다.(후에 linear, lasso, ridge도 돌려봤습니다.)
그래서 SVR과 MLP Regression을 가지고 돌려봤는데 MLP Regression이 성능이 조금더 좋은 것을 확인하고 선택했습니다.

"""

with open('/home/u1033/homework8/saved_model.pkl', 'rb') as f:
    regr = pickle.load(f)

"""

(3) Measure 
10-fold 방법을 사용했고 train_x, train_y, test_x, test_y로 나누어서 진행했습니다.
각 fold마다 mae를 출력하고 evl이라는 변수에 넣었습니다. 그리고 마지막 average해서 total MAE를 산출했습니다.

"""


evl = []
for train_idx, test_idx in fold.split(train_new2):

    train_d, test_d = train_new2.iloc[train_idx], train_new2.iloc[test_idx]
    
    train_y = train_d['Purchase']
    train_x = train_d[columns]
    
    test_y = test_d['Purchase']
    test_x = test_d[columns]

    mae = mean_absolute_error(regr.predict(test_x), test_y)
    print('fold {} :'.format(fold_idx), 'MAE =', mae)
    evl.append(mae)
    
    fold_idx += 1
    
print('Total (Average) MAE =',np.average(evl))

"""

(4) Model parameter engineering
MLP Regression모델을 구축할때 max_iter = 500 으로 높게 잡았고 early_stopping = True로 설정하여 학습으로인한 오버피팅이 일어나지 않게 하였습니다.
activation = relu로 기본값을 사용했습니다. sklearn에 들어가있는 activaion을 다 사용했지만 기본값인 relu가 가장 성능이 좋았습니다.
solver = adam을 사용했고 처음에 sgd를 사용했지만 loss값이 nan으로 나오는 상황이 있어서 adam을 사용하게 되었습니다.
learning_rate_init = 0.001을 사용했고 0.005, 0.01, 0.05를 사용했지만 0.001이 더 좋은 성능을 냈습니다.

그리고 MAE가 2000대로 성능이 그렇게 좋지않습니다. 이런방법 저런방법 많이 써보았지만 획기적인 성능개선은 없었습니다.
최적의 n_component 값을 찾아서 적용한 pca와 svd로 차원을 축소해보았지만 
일정 성능이상 좋아지지않았습니다. 오히려 변수를 다 넣고 모델을 구축하는게 더 성능이 좋았습니다.
iqr기준 이상치도 제거해보았지만 성능이 하락했습니다
randomforest의 feature importance를 활용햐여 변수 추출해보려고도 했지만 randomforest의 학습 시간이 너무 오래 걸려서 결과를 흭득하지 못했습니다.

"""
