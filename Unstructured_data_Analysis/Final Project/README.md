# ๐ Final Project

### ๐ฏ๋ชฉ์ 
[mimic ii ๋ฐ์ดํฐ](https://www.kaggle.com/datasets/drscarlat/mimic2-original-icu)๋ฅผ ๊ฐ์ง๊ณ  ํจํ์ฆ์ ๋ถ๋ฅ ํ  ์ ์๋ ๋ชจ๋ธ ๋ง๋ค๊ธฐ

### ๐๋ด์ฉ
chartevents ์ง๋ฃ์ฐจํธ , Icd9 ์ง๋ณ ์ฝ๋ ,admissions ํ์ ์์์ ๋ณด, D_codeitems ์์ดํ ์ฝ๋, drgevents drg์ ๋ณด, patients ํ์์ ๋ณด, Icustay_days ์.ํด์ ์ผ์, Demographic_detail ์ธ๊ตฌํต๊ณ_์์ธ ๋ฐ์ดํฐ๋ฅผ ์ฌ์ฉ
1. ๊ธฐ์ค์ด ๋๋ ํ์ด๋ธ(admissions, patients)๋ฅผ ์ก๊ณ  ์ปฌ๋ผ์ ๋ถ์ผ ์์ 
2. ํ์๋ง๋ค ํธํก๋ฅ , ํ์, ๋งฅ๋ฐ์, ์ฒด์จ์ ์ถ์ถํด์ ์ด๊ฒ๋ค์ mean, max, min, std, peak๋ฅผ ์นผ๋ผ์ผ๋ก ๋ถ์
3. ํด๋์ค ๋ถ๊ท ํ์ด ์ฌํ๊ด๊ณ๋ก SMOTE ์๊ณ ๋ฆฌ์ฆ์ผ๋ก Oversampling ํด์ฃผ๊ณ  LGBM์ผ๋ก ๋จธ์ ๋ฌ๋ ๋ชจ๋ธ๋ง ์งํ ๋ฐ ํ์ดํผ ํ๋ผ๋ฉํฐ ํ๋
	- ์ ํ๋ ์ฝ 91.6%
	- DNN์ ๊ฒฝ์ฐ ์ฝ 80%, Tabnet์ ์ฝ 82%
