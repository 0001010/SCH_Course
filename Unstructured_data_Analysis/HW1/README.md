# 📃 HW1

### 🎯목적
센서(시계열)데이터의 통계, Peak, 변화 분석을 통해서 머신러닝 모델 구축

### 🔎내용
기준이 되는 테이블 Har_total을 만들고 여기에 column들을 붙임
1. 통계특질
- maguserAcceleration, magrotationRate, gravity.x, gravity.y, gravity.z, magattitude 변수를 가지고 RMS, RSS, Mean, Max, Min, Std, Iqr, Kurtosis를 도출
- 랜덤포레스트로 K-Fold 10기준 정확도 93~94%

2. Peak 특질
- magrotationRate 변수를 기준으로 interval, interval_std, mean, max, min, iqr, std에 대한 Peak의 개수 추출
- 랜덤포레스트로 K-Fold 10기준 정확도 약 64%

3. 변화 분석
- magrotationRate, magrotationRate, magattitude의 mean, var, meanvar의 변화분석 추출
- 랜덤포레스트로 K-Fold 10기준 정확도 약 48%

4. 모두 결합
<img src="./image/rf.png" width="350" height="350"><br>
- 위의 1,2,3을 모두 결합했을 때 정확도 94~95%
	- 1번의 통계특질로 모델링한것보다 약간 더 올랐다.