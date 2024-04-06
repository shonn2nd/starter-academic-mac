# load packages -----------------------------------------------------------
install.packages("tidyverse")
install.packages("haven")
install.packages("labelled")
library(tidyverse)
library(haven)
library(labelled)

# import data -------------------------------------------------------------
data<-read_sav("nsch.sav")
data_c<-remove_labels(data)

# check your data ---------------------------------------------------------
data_c

glimpse(data_c)

# filter ------------------------------------------------------------------
#12-17 years old
data_c %>% 
  filter(age3_21 > 2)

#0-5 years old + male
data_c %>% 
  filter(age3_21 == 1 & sex_21 == 1)

#0-5 years old + 6-11 years old
data_c %>% 
  filter(age3_21 == 1 | age3_21 == 2)

#0-5 years old + 6-11 years old
data_c %>% 
  filter(age3_21 %in% c(1, 2))

# arrange -----------------------------------------------------------------
#ascending: one argument
data_c %>% 
  arrange(SC_AGE_YEARS)

#ascending: two arguments
data_c %>% 
  arrange(SC_AGE_YEARS, SC_SEX)

#descending: one argument
data_c %>% 
  arrange(desc(SC_AGE_YEARS))

#descending: two arguments
data_c %>% 
  arrange(desc(SC_AGE_YEARS), desc(SC_SEX))

# distinct ----------------------------------------------------------------
#state
data_c %>% 
  distinct(FIPSST)

#state while keeping the other columns
data_c %>% 
  distinct(FIPSST, .keep_all = TRUE)

# count -------------------------------------------------------------------
#the number of occurrences for each state
data_c %>% 
  count(FIPSST)

#the number of occurrences for each sex by state sorted by the number
data_c %>% 
  count(FIPSST, SC_SEX, sort=TRUE)

# mutate ------------------------------------------------------------------
#create a new variable, ACE
data_c %>% 
  mutate(
    ACE = ACEdomviol_21 + ACEjail_21
    )

#create a new variable, ACE and make it the first column
data_c %>% 
  mutate(
    ACE = ACEdomviol_21 + ACEjail_21, 
    .before = 1
    )

#create a new variable, ACE and put it after FIPPST
data_c %>% 
  mutate(
    ACE = ACEdomviol_21 + ACEjail_21, 
    .after = FIPSST
    )

#create a new variable, ACE and only retain those columns involved
data_c %>% 
  mutate(
    ACE = ACEdomviol_21 + ACEjail_21, 
    .keep = "used"
  )

# select ------------------------------------------------------------------
#select three variables
data_c %>% 
  select(FIPSST, SC_SEX, SC_AGE_YEARS)

#select variables between A and B
data_c %>% 
  select(FIPSST:A2_LIVEUSA)

#select all the variables, except for those between A and B
data_c %>% 
  select(!FIPSST:A2_LIVEUSA)

#select all the character variables
data_c %>% 
  select(where(is.character))

#starts_with("abc"): matches names that begin with “abc”.
#ends_with("xyz"): matches names that end with “xyz”.
#contains("ijk"): matches names that contain “ijk”.
#num_range("x", 1:3): matches x1, x2 and x3.
data_c %>% 
  select(starts_with("ACE"))

data_c %>% 
  select(ends_with("8"))

data_c %>% 
  select(contains("AGE"))

data_c %>% 
  select(num_range("ACE", 1:12))

# rename ------------------------------------------------------------------
#rename State FIPS Code
#new = old
data_c %>% 
  rename(state = FIPSST)

# relocate ----------------------------------------------------------------
#move SC_AGE_YEARS, SC_SEX to the front
data_c %>% 
  relocate(SC_AGE_YEARS, SC_SEX)

#move SC_AGE_YEARS, SC_SEX before STRATUM
data_c %>% 
  relocate(SC_AGE_YEARS, SC_SEX, .before = STRATUM)

#move SC_AGE_YEARS, SC_SEX after STRATUM
data_c %>% 
  relocate(SC_AGE_YEARS, SC_SEX, .after = STRATUM)

# group_by + summarize ----------------------------------------------------
#compute mean age by each state without considering missing values
data_c %>% 
  group_by(FIPSST) %>% 
  summarize(avg_age = mean(SC_AGE_YEARS))

#compute mean age by each state without considering missing values: alternative
data_c %>% 
  summarize(
    avg_age = mean(SC_AGE_YEARS),
    .by = FIPSST
            )

#compute mean age by each state and consider missing values
data_c %>% 
  group_by(FIPSST) %>% 
  summarize(avg_age = mean(SC_AGE_YEARS, na.rm = TRUE))

#compute mean age by each state, consider missing values, and indicate the number of occurrence
data %>% 
  group_by(FIPSST) %>% 
  summarize(
    avg_age = mean(SC_AGE_YEARS, na.rm = TRUE),
    n = n()
    )

#compute mean age by each state and sex, consider missing values, and indicate the number of occurrence
data %>% 
  group_by(FIPSST, SC_SEX) %>% 
  summarize(
    avg_age = mean(SC_AGE_YEARS, na.rm = TRUE),
    n = n()
  )

# slice -------------------------------------------------------------------
#df %>%  slice_head(n = 1) takes the first row from each group.
#df %>%  slice_tail(n = 1) takes the last row in each group.
#df %>%  slice_min(x, n = 1) takes the row with the smallest value of column x.
#df %>%  slice_max(x, n = 1) takes the row with the largest value of column x.
#df %>%  slice_sample(n = 1) takes one random row.

data %>% 
  group_by(FIPSST) %>% 
  slice_head(n = 1)

data %>% 
  group_by(FIPSST) %>% 
  slice_tail(n = 1)

data %>% 
  group_by(FIPSST) %>% 
  slice_min(SC_AGE_YEARS, n =1)

data %>% 
  group_by(FIPSST) %>% 
  slice_max(SC_AGE_YEARS, n =1)

data %>% 
  group_by(FIPSST) %>% 
  slice_sample(n =1)