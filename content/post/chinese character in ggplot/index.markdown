---
title: "How to Display Chinese Character in ggplot2"
output: html_document
draft: FALSE

authors: 
- admin
tags: [R, text mining, Chinese]
categories: 
- R
---

# Introduction

In this post, I am going to demonstrate how to display Chinese Character in `ggplot2`




```r
#loading necessary packages
library(rvest)
library(xml2)
library(tidyverse)
library(tidytext)
library(png)
library(knitr)
```

Let's get our text data by scraping Chien-Ming Wang's page on Wikipedia.

![test](static/images/wang.png)

```r
wang <- "https://zh.wikipedia.org/wiki/%E7%8E%8B%E5%BB%BA%E6%B0%91_(%E6%A3%92%E7%90%83%E5%93%A1)"
wanghtml <- read_html(wang)
wanghtml
```

```
## {html_document}
## <html class="client-nojs" lang="zh" dir="ltr">
## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...
## [2] <body class="mediawiki ltr sitedir-ltr mw-hide-empty-elt ns-0 ns-subject  ...
```

```r
str(wanghtml)
```

```
## List of 2
##  $ node:<externalptr> 
##  $ doc :<externalptr> 
##  - attr(*, "class")= chr [1:2] "xml_document" "xml_node"
```


```r
body_nodes <- wanghtml %>% 
 html_node("body") %>% 
 html_children()
body_nodes
```

```
## {xml_nodeset (9)}
## [1] <div id="mw-page-base" class="noprint"></div>
## [2] <div id="mw-head-base" class="noprint"></div>
## [3] <div id="content" class="mw-body" role="main">\n\t<a id="top"></a>\n\t<di ...
## [4] <div id="mw-data-after-content">\n\t<div class="read-more-container"></di ...
## [5] <div id="mw-navigation">\n\t<h2>导航菜单</h2>\n\t<div id="mw-head">\n\t\t<nav ...
## [6] <footer id="footer" class="mw-footer" role="contentinfo"><ul id="footer-i ...
## [7] <script>(RLQ=window.RLQ||[]).push(function(){mw.config.set({"wgPageParseR ...
## [8] <script type="application/ld+json">{"@context":"https:\\/\\/schema.org"," ...
## [9] <script>(RLQ=window.RLQ||[]).push(function(){mw.config.set({"wgBackendRes ...
```


```r
bio <- wanghtml %>% 
  rvest::html_nodes('body') %>% 
  xml2::xml_find_all("//div[contains(@class, 'mw-body-content mw-content-ltr')]") %>% 
  rvest::html_text()

bio_df <- data.frame(bio)
bio_df<-gsub("臺灣出生大聯盟選手列表.*","",bio_df)
bio_df <- data.frame(bio_df)
bio_df<-bio_df %>% rename(text = 1)
```


```r
toks<-bio_df %>%
  unnest_tokens(word, text) %>% filter(!str_detect(word, "[:digit:]") &
                                          !str_detect(word, "[a-z]")) 
toks%>%
  count(word, sort = TRUE) %>%
  filter(n > 60) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />


```r
library(showtext)
```

```
## Loading required package: sysfonts
```

```
## Loading required package: showtextdb
```

```r
showtext_auto()

toks%>%
  count(word, sort = TRUE) %>%
  filter(n > 60) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL) +
  labs(x = "Frequency")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />


```r
bio_clean<-bio_df$text %>%
  str_remove_all("\\n|[:digit:]|[:lower:]|[:upper:]|[:punct:]") %>% as.data.frame() %>% rename(text = 1)

toks<-bio_clean %>% unnest_tokens(word, text, token = "ngrams", n = 2)

toks%>%
  count(word, sort = TRUE) %>%
  filter(n > 8) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL) +
  labs(x = "Frequency")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />
