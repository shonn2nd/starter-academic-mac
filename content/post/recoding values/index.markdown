---
title: "Recoding Values"
output: html_document
---



## Introduction

Recoding values is one of the most common tasks a researcher needs to before data analysis. For me, often I need to prepare my data in R first before using it for advanced statistical analyses in M*plus*. In this case, it is important to recode missing values to a specific extreme value (e.g., -999) since it will be more efficient for M*plus* to recognize and handle missing values. In this post, I will demonstrate a way to handle the recording task using `case_when` function in `Tidyverse`. There are different ways to get this job done, but I felt that `case_when` makes the most sense to me. Let's get started.


```r
#load required packages
library(tidyverse)
```

Create a hypothetical dataset

```r
data<-data.frame(cost1 = c(2, 3, 4, 2, NA),
             cost2 = c(1, 2, 3, 4, 5),
             cost3 = c(NA, NA, 3, 2, 1)
             )
data
```

```
##   cost1 cost2 cost3
## 1     2     1    NA
## 2     3     2    NA
## 3     4     3     3
## 4     2     4     2
## 5    NA     5     1
```

### Task 1: Recode Missing Values to -999

```r
#slow way: deal with one variable at a time
data %>% 
  mutate(
    cost1 = case_when(
    is.na(cost1) ~ -999, 
    TRUE ~ as.numeric(cost1)),
    cost3 = case_when(
    is.na(cost3) ~ -999, 
    TRUE ~ as.numeric(cost3))
    )
```

```
##   cost1 cost2 cost3
## 1     2     1  -999
## 2     3     2  -999
## 3     4     3     3
## 4     2     4     2
## 5  -999     5     1
```

```r
#quicker way: deal with multiple variables at a time
data %>% 
  mutate(across(cost1:cost3, ~ case_when(
    is.na(.) ~ -999, 
    TRUE ~ as.numeric(.)
  )))
```

```
##   cost1 cost2 cost3
## 1     2     1  -999
## 2     3     2  -999
## 3     4     3     3
## 4     2     4     2
## 5  -999     5     1
```
### Task 2: Recode Values for Reverse Items
