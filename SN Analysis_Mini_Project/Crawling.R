library(httr)
library(rvest)
library(dplyr)
library(urltools)

setwd('C:\\Users\\icear\\OneDrive\\바탕 화면\\4학기\\소셜네트워크 분석')
uni <- read.csv('고등교육기관 하반기 주소록(2020).csv')
uni <- subset(uni, 학교종류=='대학교' | 학교종류=='교육대학')

uni
univer_encode <- vector()
university <- vector()
SearchWordss <- vector()

# 학교명 추출 및 인코딩
for (w in uni$학교명){
  univer_encode <- append(univer_encode, w %>% url_encode())
}

# 크롤링 과정
for (i in univer_encode){
  SearchWords <- GET(url = paste0('https://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&sq=&o=&q=',i)) %>%
    read_html() %>% 
    html_nodes(css = '#netizen_lists_top > span.wsn') %>% 
    html_text() %>% iconv(from = 'UTF-8', to ='EUC-KR')
  
  dec <- url_decode(i)
  SearchWordss<- append(SearchWordss, SearchWords)
  university <- append(university, rep(dec,length(SearchWords)))
}

# data frame 생성
df <- data.frame(university, SearchWordss)
df