# ๐ HW1

### ๐ฏ๋ชฉ์ 
์ผ์(์๊ณ์ด)๋ฐ์ดํฐ์ ํต๊ณ, Peak, ๋ณํ ๋ถ์์ ํตํด์ ๋จธ์ ๋ฌ๋ ๋ชจ๋ธ ๊ตฌ์ถ

### ๐๋ด์ฉ
๊ธฐ์ค์ด ๋๋ ํ์ด๋ธ Har_total์ ๋ง๋ค๊ณ  ์ฌ๊ธฐ์ column๋ค์ ๋ถ์
1. ํต๊ณํน์ง
- maguserAcceleration, magrotationRate, gravity.x, gravity.y, gravity.z, magattitude ๋ณ์๋ฅผ ๊ฐ์ง๊ณ  RMS, RSS, Mean, Max, Min, Std, Iqr, Kurtosis๋ฅผ ๋์ถ
- ๋๋คํฌ๋ ์คํธ๋ก K-Fold 10๊ธฐ์ค ์ ํ๋ 93~94%

2. Peak ํน์ง
- magrotationRate ๋ณ์๋ฅผ ๊ธฐ์ค์ผ๋ก interval, interval_std, mean, max, min, iqr, std์ ๋ํ Peak์ ๊ฐ์ ์ถ์ถ
- ๋๋คํฌ๋ ์คํธ๋ก K-Fold 10๊ธฐ์ค ์ ํ๋ ์ฝ 64%

3. ๋ณํ ๋ถ์
- magrotationRate, magrotationRate, magattitude์ mean, var, meanvar์ ๋ณํ๋ถ์ ์ถ์ถ
- ๋๋คํฌ๋ ์คํธ๋ก K-Fold 10๊ธฐ์ค ์ ํ๋ ์ฝ 48%

4. ๋ชจ๋ ๊ฒฐํฉ
- ์์ 1,2,3์ ๋ชจ๋ ๊ฒฐํฉํ์ ๋ ์ ํ๋ 94~95%<br></br>
<img src="./image/rf.PNG" width="650" height="500"><br>