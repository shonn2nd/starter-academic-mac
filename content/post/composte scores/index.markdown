---
title: "Computing Composite Scores (Mean)"
output: html_document
# Date published
date: "2021-07-23T00:00:00Z"

authors: 
- admin
tags: [R, explore]
categories: 
- R
---



## Introduction

In this post, I am going to demonstrate how to compute composite scores or means aggregated over multiple items. There are **at least** two approaches to achieve the goal.    

Let's load necessary packages first.


```r
library(tidyverse)
```

Create hypothetical data sets: one with complete data and one with missing values.


```r
#id = unique id number for each participant
#se refers self-efficacy
#se1 refers to the first survey item of the self-efficacy scale
mydata<-data.frame(
  id = c(1:3),
  se1 = c(1, 3, 4),
  se2 = c(2, 2, 5),
  se3 = c(1, 3, 3)
)

missdata<-data.frame(
  id = c(1:3),
  se1 = c(1, 3, 4),
  se2 = c(NA, 2, 5),
  se3 = c(1, 3, NA)
)
```

Check our data set.

```r
mydata
```

```
##   id se1 se2 se3
## 1  1   1   2   1
## 2  2   3   2   3
## 3  3   4   5   3
```

```r
missdata
```

```
##   id se1 se2 se3
## 1  1   1  NA   1
## 2  2   3   2   3
## 3  3   4   5  NA
```

We are ready to explore the data.

## First Approach: R Base Functions
Since we are interested in computing means, `rowMeans` will do the work. We need to create a new variable called **se** to represent each participant's overall level of self-efficacy and specify what columns or items are needed for computing the composite score for each person (mean in this case). Let's play with our complete data set `mydata` first.

```r
mydata$se<-rowMeans(mydata[, c("se1", "se2", "se3")], na.rm=T)
mydata
```

```
##   id se1 se2 se3       se
## 1  1   1   2   1 1.333333
## 2  2   3   2   3 2.666667
## 3  3   4   5   3 4.000000
```
`na.rm` is an argument for determining how to deal with cases with missing values. It is not particularly relevant here since there is no missing value in `mydata`. 

## Second Approach: Tidyverse


```r
mydata %>% mutate (se = rowMeans(select(., c("se1", "se2", "se3")), na.rm=T))
```

```
##   id se1 se2 se3       se
## 1  1   1   2   1 1.333333
## 2  2   3   2   3 2.666667
## 3  3   4   5   3 4.000000
```
`mutate` is a great function to **create** new variables. `select` is another function to **select** the variables needed. **.** (dot) refers to `mydata`. Here, `na.rm` is also not particularly relevant here since there is no missing value. It looks like we have identical values. Good!

## Deal with Missing Values

`na.rm` will be relevant when dealing with data containing missing values. `na.rm = FALSE` is very similar to the idea of **list-wise deletion**. That is, R will not compute the composite score for any row or person that contains a missing value for the items you selected. On the contrary, `na.rm = TRUE` is very similar to the idea of the **full information** approach. That is, R will utilize all the possible information from the items to compute the mean. If there is a missing value in one of the three items, R will still compute the mean based on the values of the other two items. 


```r
#list-wise deletion approach
missdata$list<-rowMeans(missdata[, c("se1", "se2", "se3")], na.rm=F)
#full information approach
missdata$full<-rowMeans(missdata[, c("se1", "se2", "se3")], na.rm=T)
missdata
```

```
##   id se1 se2 se3     list     full
## 1  1   1  NA   1       NA 1.000000
## 2  2   3   2   3 2.666667 2.666667
## 3  3   4   5  NA       NA 4.500000
```
As you can see here, since there is a missing value for person 1 and person 3 in one of the self-efficacy items, `na.rm=F` will discard all the other information from items that do contain information and will not compute the mean for that person. On the contrary, `na.rm=T` will still compute the mean based on the information from items that do not have missing values. This idea is the same when using Tidyverse.




```r
#list-wise deletion approach
missdata %>% mutate (list = rowMeans(select(., c("se1", "se2", "se3")), na.rm=F))
```

```
##   id se1 se2 se3     list
## 1  1   1  NA   1       NA
## 2  2   3   2   3 2.666667
## 3  3   4   5  NA       NA
```

```r
#full information approach
missdata %>% mutate (full = rowMeans(select(., c("se1", "se2", "se3")), na.rm=T))
```

```
##   id se1 se2 se3     full
## 1  1   1  NA   1 1.000000
## 2  2   3   2   3 2.666667
## 3  3   4   5  NA 4.500000
```
We have the identical results here. Using the full information approach `na.rm=T`, for person 1, the mean is 1 ((1+1)/2) despite a missing value for item 2.
