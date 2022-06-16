# 📃 Final Project

### 🎯목적
[mimic ii 데이터](https://www.kaggle.com/datasets/drscarlat/mimic2-original-icu)를 가지고 패혈증을 분류 할 수 있는 모델 만들기

### 🔎내용
chartevents 진료차트 , Icd9 질병 코드 ,admissions 환자 입원정보, D_codeitems 아이템 코드, drgevents drg정보, patients 환자정보, Icustay_days 입.퇴원 일자, Demographic_detail 인구통계_상세 데이터를 사용
1. 기준이 되는 테이블(admissions, patients)를 잡고 컬럼을 붙일 예정
2. 환자마다 호흡률, 혈압, 맥박수, 체온을 추출해서 이것들의 mean, max, min, std, peak를 칼럼으로 붙임
3. 클래스 불균형이 심한관계로 SMOTE 알고리즘으로 Oversampling 해주고 LGBM으로 머신러닝 모델링 진행 및 하이퍼 파라메터 튜닝
	- 정확도 약 91.6%
	- DNN의 경우 약 80%, Tabnet은 약 82%
