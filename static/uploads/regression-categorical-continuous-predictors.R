# install/load packages ---------------------------------------------------
install.packages("tidyverse")
install.packages("psych")
install.packages("haven")
install.packages("fastDummies")
library(tidyverse)
library(psych)
library(haven)
library(fastDummies)

# import data ------------------------------------------------------------
data<-read_sav("nsch.sav")

# regression: X as a continuous predictor ---------------------------------
#x = ScreenTime_21 (Time spent in front of a TV, computer, cellphone or other electronic device watching programs, playing games, accessing the internet or using social media, not including schoolwork )
#y = K7Q82_R (How often does this child (not) care about doing well in school?)

data$ScreenTime_21
table(data$ScreenTime_21)

data$K7Q82_R
table(data$K7Q82_R)
data<-data %>% filter(K7Q82_R < 5)

fit<-lm(K7Q82_R ~ ScreenTime_21, data=data)
summary(fit)

# regression: X as a categorical predictor ---------------------------------
#x = race7_21 (racial group)
#y = K7Q82_R (How often does this child (not) care about doing well in school?)

data$race7_21
table(data$race7_21)

#this is wrong
fit<-lm(K7Q82_R ~ race7_21, data=data)
summary(fit)

#this is correct
data<-data %>% dummy_cols(select_columns = "race7_21")

fit<-lm(K7Q82_R ~ race7_21_1 + race7_21_2 + race7_21_4 + race7_21_5 + race7_21_6 + race7_21_7, data=data)
summary(fit)

# regression: categorical predictor + continuous predictor ----------------

fit<-lm(K7Q82_R ~ race7_21_1 + race7_21_2 + race7_21_4 + race7_21_5 + race7_21_6 + race7_21_7 + SC_AGE_YEARS, data=data)
summary(fit)
