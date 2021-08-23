---
title: "Recoding Values"
output: html_document
# Date published
date: "2021-08-22T00:00:00Z"

authors: 
- admin
tags: [R, data wrangling]
categories: 
- R
---



## Introduction

Recoding values is one of the most common tasks a researcher needs to before data analysis. For me, often I need to prepare my data in R first before using it for advanced statistical analyses such as M*plus*. In this case, it is important to recode missing values to a specific extreme value (e.g., -999) since it will be more efficient for M*plus* to recognize and handle missing values. In this post, I will demonstrate a way to handle the recording task using `case_when` function in Tidyverse. There are different ways to get this job done, but I feel that `case_when` makes the most sense to me. Let's get started.


```r
#load required packages
library(tidyverse)
```

Let's create a hypothetical dataset!

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

Let's first try a slow way to recode the missing values to -999:


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

`is.na(cost1) ~ -999` asks R to evaluate if a specific case is missing information in **cost1**. If a case is missing, then it will be coded as **-999**. `TRUE ~ as.numeric(cost1)` means that if a specific case is not a missing value in **cost1**, then it will not be changed and will remain as the same numeric value as it was. This approach is ok if you are dealing with a couple of variables. However, if you are to recode several variables at the same time, then, this approach is not efficient. We need a faster way.


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

As it is shown here, all we need is `across` function and specify what variables we are going to recode. **Dot (.)** refers to the selected variables (i.e., cost1, cost2, cost3). This block of codes ask R to recode missing values across cost1 to cost3 as -999 and for cases that contain information, they will remain the same numeric value as they were.


### Task 2: Recode Values for Reverse Items

[under construction]
