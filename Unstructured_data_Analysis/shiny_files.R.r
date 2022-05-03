library(stringr)
library(dplyr)
library(moments)
library(tidyverse)
library(RWeka)

library(seewave)
library(fBasics)
library(signal)
library(pracma)

library(e1071)
library(pracma)
library(changepoint)

library(shiny)
library(shinythemes)

#------------------Data import------------------#

path = 'C:/Users/icear/OneDrive/바탕 화면/6학기/비정형데이터분석/motion-sense-master/data/A_DeviceMotion_data/A_DeviceMotion_data'
setwd(path)


fls <- dir(path, recursive = TRUE)
  
for(f in fls){
  a <- file.path(str_c(path, "/", f))
  temp <- read.csv(a)
  assign(f, temp) 
}

HAR_total <- data.frame()

for(f in fls){
  temp <- get(f)
  HAR_total <- rbind(HAR_total, temp%>%mutate(exp_no = unlist(regmatches(f, gregexpr("[[:digit:]]+", f)[1]))[1],
                                              id = unlist(regmatches(f, gregexpr("[[:digit:]]+", f)[1]))[2], 
                                              activity = unlist(str_split(f,"\\_"))[1]))}


#-------------------------------------------------#


#------------------Define function------------------#

# mag 함수
mag <- function(df, column){
  df[, str_c('mag', column)] <- 
    with(df, 
         sqrt(get(str_c(column, ".x"))^2 + get(str_c(column,".y"))^2 + get(str_c(column, ".z"))^2))
  return (df)
}

# skewness 함수
skewnesss <- function(x){
  (sum((x-mean(x))^3)/length(x)) / ((sum((x-mean(x))^2)/length(x)))^(3/2)
}

# rss 함수
rss <- function(x) rms(x)*(length(x))^0.5

# mode 함수(최빈값)
modes <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

RF <- make_Weka_classifier("weka/classifiers/trees/RandomForest")

#---------------------------------------------#

#--------------------UI-----------------------#

ui <- fluidPage(
  theme = shinytheme(theme = 'united'),
  titlePanel(h1('비정형 데이터 분석 과제', align = "center")),
  h4('20171481 박은총', align = "right"),
  
  sidebarPanel(tabsetPanel(
    
    # stat 
    tabPanel(title = 'stat setting',
      
      selectInput(inputId = 'vars',
                  label = '사용할 변수 선택하세요',
                  choices = NULL,
                  multiple = TRUE),
      
      selectInput(inputId = 'mag_var',
                  label = 'mag연산 할 컬럼을 선택하세요',
                  choices = NULL,
                  multiple = TRUE),
      
      selectInput(inputId = 'stat_calc',
                  label = '통계연산에 쓰일 함수를 선택하세요',
                  choices = NULL,
                  multiple = TRUE),
      
      submitButton(text = '변경사항을 적용합니다.',
                   icon = icon(name = 'sync'))
    ),
    
    # peak
    tabPanel(title = 'peaks setting',
             
             selectInput(inputId = 'mag_var2',
                         label = 'mag연산 할 컬럼을 선택하세요',
                         choices = NULL,
                         multiple = TRUE),
             
             numericInput(inputId = 'threshold_num',
                          label = 'peak의 threshold의 값을 정해주세요',
                          value = 4,
                          min = 1,
                          max = 10),
             
             sliderInput(inputId = 'crest_HZ',
                         label = 'crest의 f값(HZ값)을 넣어주세요',
                         value = 50,
                         min = 0,
                         max = 1000),
             submitButton(text = '변경사항을 적용합니다.',
                          icon = icon(name = 'sync'))),
    
    # change point
    tabPanel(title = 'change point setting'))
),
  

  mainPanel(
    uiOutput(outputId = 'mainUI')
  )
)
#---------------------------------------------#

#-------------------SERVER--------------------#

server <- function(input, output, session){
  
  # stat observe
  observe({
    colss <- c('userAcceleration', 'rotationRate')
    stats_funcotion <- c("mean", "min", "max", "sd", "skewness", "rms" , "rss", "IQR" , "kurtosis", "modes")
    varss <- colnames(HAR_total)
    
    updateSelectInput(session = session, inputId = 'mag_var', choices = colss)
    updateSelectInput(session = session, inputId = 'stat_calc', choices = stats_funcotion)
    updateSelectInput(session = session, inputId = 'vars', choices = varss)
  })
  
  # peak observe
  observe({
    colss2 <- c('userAcceleration', 'rotationRate')
    peak_threshold <- input$threshold_num
    hz <- input$crest_HZ
    
    updateSelectInput(session = session, inputId = 'mag_var2', choices = colss2)
    updateNumericInput(session = session, inputId = 'threshold_num', value = peak_threshold)
    updateNumericInput(session = session, inputId = 'crest_HZ', value = hz)
  })
  
  # stat render for shiny app
  output$table <- renderText({
    HAR_total <- HAR_total %>% select(input$vars)
    HAR_total <- mag(HAR_total, input$mag_var)
    
    HAR_summary <- HAR_total %>% group_by(id, exp_no, activity) %>%
      summarize_at(.var = c("maguserAcceleration", "magrotationRate","gravity.x","gravity.y","gravity.z"), .funs = c(mean, min, max, sd, skewness))
    
    HAR_summary_extend <- HAR_total %>% group_by(id, exp_no, activity)%>%
      summarise_at(.vars = c("maguserAcceleration", "magrotationRate","gravity.x","gravity.y","gravity.z"),.funs = input$stat_calc)
    HAR_summary_extend2 <- HAR_summary_extend %>% ungroup() %>% select(-c("id", "exp_no")) 
    activity <- HAR_summary%>%ungroup()%>%select(c(colnames(HAR_summary)[str_detect(colnames(HAR_summary),"mag")],"activity"))
    
    
    m <- RF(as.factor(activity)~., data = HAR_summary_extend2)
    e <- evaluate_Weka_classifier(m, numFolds = 10, complexity = TRUE, class = TRUE)
    
    s <- as.character(e$string)
    s
  })
  
  # peak render for shiny app
  output$peaks <- renderText({
    
    for (d in fls){
      f <- get(d) 
      f <- mag(f, input$mag_var2)
      assign(d, f)
    }
    peak_rslt <- data.frame()
    
    for (d in fls){
      f <- get(d)
      p <- findpeaks(f$magrotationRate, threshold = input$threshold_num) 
      peak_rslt <- rbind(peak_rslt, data.frame(d, 
                                               f_n = ifelse(!is.null(p), dim(p)[1],0),
                                               p_interval = ifelse(!is.null(p), ifelse(dim(p)[1]>1, mean(diff(sort(p[,2]))),0),0),
                                               p_interval_std = ifelse(!is.null(p), ifelse(dim(p)[1]>2, std(diff(sort(p[,2]))),0),0), 
                                               p_mean = ifelse(!is.null(p), mean(p[,1]),0), 
                                               p_max = ifelse(!is.null(p), max(p[,1]),0),
                                               p_min = ifelse(!is.null(p), min(p[,1]),0),
                                               p_med = ifelse(!is.null(p), median(p[,1]),0),
                                               p_iqr = ifelse(!is.null(p), ifelse(dim(p)[1]>1, IQR(p[,1]),0),0),
                                               p_std = ifelse(!is.null(p), ifelse(dim(p)[1]>1, std(p[,1]),0),0)))
    }
    
    temp <- get(fls[1])
    p_temp <- findpeaks(temp$magrotationRate, threshold = 4)
    
    temp <- data.frame()
    
    
    for (d in fls){
      f <- get(d)
      f <- f %>% select(magrotationRate, maguserAcceleration)
      cfR <- crest(f$magrotationRate, input$crest_HZ)
      cfA <- crest(f$maguserAcceleration, input$crest_HZ)
      temp <- rbind(temp, data.frame(d, cfR = cfR$C, cfA = cfA$C)) 
    }
    
    peak_final <- merge(peak_rslt, temp, by = "d")
    
    id_f <- function(x){
      exp_no = unlist(regmatches(x, gregexpr("[[:digit:]]+", x)[1]))[1]
      id = unlist(regmatches(x, gregexpr("[[:digit:]]+",x)[1]))[2]
      activity = unlist(str_split(x,"\\_"))[1]
      
      return(cbind(exp_no,id, activity))
    }
    
    
    temp <- data.frame()
    for (i in 1:nrow(peak_final)){
      temp <- rbind(temp, id_f(peak_final$d[i]))
    }
    
    peak_final2 <- cbind(peak_final, temp)
    peak_final2
    
    activity_peak <- peak_final2 %>% ungroup() %>% select(-d, -exp_no, -id)
    
    m <- RF(as.factor(activity)~., data = activity_peak)
    e <- evaluate_Weka_classifier(m, numFolds = 10, complexity = TRUE, class = TRUE)
    
    s <- as.character(e$string)
    s
  })
  

  # Main UI
  output$mainUI <- renderUI({
    tabsetPanel(
      tabPanel(title = 'stat',
               h4('Random Forest Result Report'),
               
               verbatimTextOutput(outputId = 'table'),
               ),
        
      tabPanel(title = 'peaks',
               h4('Random Forest Result Report'),
               
               verbatimTextOutput(outputId = 'peaks')),
      
      tabPanel(title = 'change point',
               h4('Random Forest Result Report'),
               
               tableOutput(outputId = 'stat_rf'))
        
      )
    })
  }
#---------------------------------------------#


############ SHINY APP ############
shinyApp(ui = ui, server = server)#
###################################

# 데이터를 불러오는데 생각보다 오래 걸리니 참고바랍니다.