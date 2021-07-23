---
title: "Compute Composite Scores"
output: html_document
# Date published
date: "2021-07-23T00:00:00Z"

authors: 
- admin
tag: 
- R
categories: 
- R
---



## Introduction

Computing composite scores is very common in educational research since for many studies, the primary interest is to examine the relations between constructs, not items. For instance, you may be interested in the relation between academic self-efficacy and academic achievement, and academic self-efficacy is measured by multiple similar items. In this post, I am going to show you how to compute composite scores or means aggregated over multiple items. There are at least two approaches to achieve the goal.    

Let's load necessary packages first.


```r
library(tidyverse)
```

Also, let's take a quick look at our data set.


```r
mpg
```

```
## # A tibble: 234 x 11
##    manufacturer model    displ  year   cyl trans   drv     cty   hwy fl    class
##    <chr>        <chr>    <dbl> <int> <int> <chr>   <chr> <int> <int> <chr> <chr>
##  1 audi         a4         1.8  1999     4 auto(l… f        18    29 p     comp…
##  2 audi         a4         1.8  1999     4 manual… f        21    29 p     comp…
##  3 audi         a4         2    2008     4 manual… f        20    31 p     comp…
##  4 audi         a4         2    2008     4 auto(a… f        21    30 p     comp…
##  5 audi         a4         2.8  1999     6 auto(l… f        16    26 p     comp…
##  6 audi         a4         2.8  1999     6 manual… f        18    26 p     comp…
##  7 audi         a4         3.1  2008     6 auto(a… f        18    27 p     comp…
##  8 audi         a4 quat…   1.8  1999     4 manual… 4        18    26 p     comp…
##  9 audi         a4 quat…   1.8  1999     4 auto(l… 4        16    25 p     comp…
## 10 audi         a4 quat…   2    2008     4 manual… 4        20    28 p     comp…
## # … with 224 more rows
```

Create unique ID and assume each row represents a unique case


```r
mpg$id <- seq.int(nrow(mpg))
```

## First Approach


```r
mpg$eff<-rowMeans(mpg[,c("displ", "cyl")], na.rm=T)
```

## Second Approach


```r
mpg %>% mutate (eff2 = rowMeans(select(.,c(displ, cyl)), na.rm=T))
```

```
## # A tibble: 234 x 14
##    manufacturer model    displ  year   cyl trans   drv     cty   hwy fl    class
##    <chr>        <chr>    <dbl> <int> <int> <chr>   <chr> <int> <int> <chr> <chr>
##  1 audi         a4         1.8  1999     4 auto(l… f        18    29 p     comp…
##  2 audi         a4         1.8  1999     4 manual… f        21    29 p     comp…
##  3 audi         a4         2    2008     4 manual… f        20    31 p     comp…
##  4 audi         a4         2    2008     4 auto(a… f        21    30 p     comp…
##  5 audi         a4         2.8  1999     6 auto(l… f        16    26 p     comp…
##  6 audi         a4         2.8  1999     6 manual… f        18    26 p     comp…
##  7 audi         a4         3.1  2008     6 auto(a… f        18    27 p     comp…
##  8 audi         a4 quat…   1.8  1999     4 manual… 4        18    26 p     comp…
##  9 audi         a4 quat…   1.8  1999     4 auto(l… 4        16    25 p     comp…
## 10 audi         a4 quat…   2    2008     4 manual… 4        20    28 p     comp…
## # … with 224 more rows, and 3 more variables: id <int>, eff <dbl>, eff2 <dbl>
```
