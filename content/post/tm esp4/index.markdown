---
title: "Text Mining: Episodio 4"
output: html_document
draft: true
# Date published
date: "2021-08-26T00:00:00Z"

authors: 
- admin
tags: [R, text mining]
categories: 
- R
---



## Introduction

In this post, I am going to play around text mining using R. This is simply for my own practice and for fun. I am deeply indebted to the instructors at [The Laser Institute](https://www.fi.ncsu.edu/projects/laser-institute/) and text mining guru [Julia Silge](https://juliasilge.com/) and [David Robinson](http://varianceexplained.org/posts/), who make text mining using R so accessible to laypersons like me!!

Let's load necessary packages first.


```r
library(tidyverse)
library(tidytext)
library(tidyr)
library(xlsx)
library(forcats)
library(igraph)
library(ggraph)
```


```r
#import our data
data<-read.xlsx("data.xlsx", sheetIndex = 1)

#check out dataset
#turn our dataset into a tibble
data<-as_tibble(data)
data
```

```
## # A tibble: 1,916 x 7
##    NA.   date    num_comments title                          topic      id group
##    <chr> <chr>          <dbl> <chr>                          <chr>   <dbl> <chr>
##  1 1     26-08-…            1 It?s time to rethink air cond… climat…     1 cg   
##  2 2     26-08-…            3 95% of existing ocean climate… climat…     2 cg   
##  3 3     26-08-…            0 Thwaites Glacier: Hidden Rive… climat…     3 cg   
##  4 4     26-08-…            1 Coming up on the outside - th… climat…     4 cg   
##  5 5     26-08-…            4 Supercomputing Experts React … climat…     5 cg   
##  6 6     26-08-…           46 People needed for a climate t… climat…     6 cg   
##  7 7     25-08-…            1 Riding the 'hydrogen wave': A… climat…     7 cg   
##  8 8     25-08-…           67 What can a 15 yo teen with no… climat…     8 cg   
##  9 9     25-08-…            5 Global electric power demand … climat…     9 cg   
## 10 10    25-08-…            1 The Caldor Fire Heads Toward … climat…    10 cg   
## # … with 1,906 more rows
```


```r
#Relationships between words: 2-grams and correlations
#tokenization
cg_bigrams <- data %>% filter(group == "cg") %>% 
  unnest_tokens(bigram, title, token = "ngrams", n = 2)

stats_bigrams <- data %>% filter(group == "stats") %>% 
  unnest_tokens(bigram, title, token = "ngrams", n = 2)

#check frequency for cg
cg_bigrams %>%
  count(bigram, sort = TRUE)
```

```
## # A tibble: 8,057 x 2
##    bigram             n
##    <chr>          <int>
##  1 climate change   281
##  2 in the            50
##  3 of the            38
##  4 of climate        34
##  5 on climate        24
##  6 the climate       19
##  7 the world         19
##  8 to climate        19
##  9 change is         18
## 10 climate crisis    15
## # … with 8,047 more rows
```

```r
#check frequency for stats
stats_bigrams %>%
  count(bigram, sort = TRUE)
```

```
## # A tibble: 7,348 x 2
##    bigram          n
##    <chr>       <int>
##  1 q how          65
##  2 how to         49
##  3 q what         45
##  4 in a           36
##  5 of the         32
##  6 for a          29
##  7 can i          26
##  8 q is           26
##  9 time series    26
## 10 is there       25
## # … with 7,338 more rows
```

Not particularly meaning here. Too many stop words.


```r
#separate bigrams into two columns
cg_bigrams_separated <- cg_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

stats_bigrams_separated <- stats_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

#remove stop words
#still separated
cg_bigrams_filtered <- cg_bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

stats_bigrams_filtered <- stats_bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts without stop words for cg:
cg_bigram_counts <- cg_bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)
cg_bigram_counts
```

```
## # A tibble: 2,495 x 3
##    word1      word2         n
##    <chr>      <chr>     <int>
##  1 climate    change      281
##  2 climate    crisis       15
##  3 fight      climate      11
##  4 global     warming      11
##  5 heat       wave         11
##  6 co2        emissions     9
##  7 sea        level         9
##  8 carbon     capture       8
##  9 greenhouse gas           8
## 10 gas        emissions     7
## # … with 2,485 more rows
```

```r
# new bigram counts without stop words for stats:
stats_bigram_counts <- stats_bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)
stats_bigram_counts
```

```
## # A tibble: 1,833 x 3
##    word1      word2            n
##    <chr>      <chr>        <int>
##  1 time       series          26
##  2 chi        squared         13
##  3 statistics discussion      12
##  4 linear     regression      10
##  5 logistic   regression      10
##  6 machine    learning        10
##  7 mixed      effects          9
##  8 squared    test             9
##  9 hypothesis testing          8
## 10 normal     distribution     8
## # … with 1,823 more rows
```

Now, this is much meaningful. A lot of people have been making posts related to climate change, climate crisis, and fight climate on the climate change forum and time series on the statistics forum.


```r
#combine separate words for cg
cg_bigrams_united <- cg_bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")
cg_bigrams_united
```

```
## # A tibble: 3,084 x 7
##    NA.   date     num_comments topic            id group bigram            
##    <chr> <chr>           <dbl> <chr>         <dbl> <chr> <chr>             
##  1 1     26-08-21            1 climatechange     1 cg    rethink air       
##  2 1     26-08-21            1 climatechange     1 cg    air conditioning  
##  3 2     26-08-21            3 climatechange     2 cg    existing ocean    
##  4 2     26-08-21            3 climatechange     2 cg    ocean climates    
##  5 2     26-08-21            3 climatechange     2 cg    co2 emissions     
##  6 2     26-08-21            3 climatechange     2 cg    emissions continue
##  7 3     26-08-21            0 climatechange     3 cg    thwaites glacier  
##  8 3     26-08-21            0 climatechange     3 cg    glacier hidden    
##  9 3     26-08-21            0 climatechange     3 cg    hidden rivers     
## 10 3     26-08-21            0 climatechange     3 cg    warm water        
## # … with 3,074 more rows
```

```r
#combine separate words for stats
stats_bigrams_united <- stats_bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")
stats_bigrams_united
```

```
## # A tibble: 2,247 x 7
##    NA.   date     num_comments topic         id group bigram                 
##    <chr> <chr>           <dbl> <chr>      <dbl> <chr> <chr>                  
##  1 923   26-08-21            0 statistics     1 stats arranging 2m           
##  2 923   26-08-21            0 statistics     1 stats 2m people              
##  3 924   26-08-21            0 statistics     2 stats clusterings partition  
##  4 924   26-08-21            0 statistics     2 stats partition cells        
##  5 924   26-08-21            0 statistics     2 stats scrna seq              
##  6 924   26-08-21            0 statistics     2 stats rand index             
##  7 924   26-08-21            0 statistics     2 stats index uncertainty      
##  8 924   26-08-21            0 statistics     2 stats uncertainty coefficient
##  9 926   26-08-21            0 statistics     4 stats adding noise           
## 10 927   26-08-21            3 statistics     5 stats drugs extrapolating    
## # … with 2,237 more rows
```


```r
#Relationships between words: 3-grams and correlations
data %>% filter(group == "cg") %>%
  unnest_tokens(trigram, title, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)
```

```
## # A tibble: 1,312 x 4
##    word1      word2       word3           n
##    <chr>      <chr>       <chr>       <int>
##  1 <NA>       <NA>        <NA>           35
##  2 fight      climate     change         11
##  3 greenhouse gas         emissions       7
##  4 sea        level       rise            7
##  5 combat     climate     change          4
##  6 atlantic   meridional  overturning     3
##  7 climate    change      science         3
##  8 global     climate     change          3
##  9 greenland  ice         sheet           3
## 10 meridional overturning circulation     3
## # … with 1,302 more rows
```

```r
data %>% filter(group == "stats")  %>%
  unnest_tokens(trigram, title, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)
```

```
## # A tibble: 743 x 4
##    word1     word2   word3           n
##    <chr>     <chr>   <chr>       <int>
##  1 chi       squared test            9
##  2 time      series  analysis        6
##  3 time      series  data            6
##  4 linear    mixed   effects         5
##  5 mixed     effects models          5
##  6 time      series  forecasting     3
##  7 analyzing survey  data            2
##  8 central   limit   theorem         2
##  9 exp       lt      ln              2
## 10 financial time    series          2
## # … with 733 more rows
```

Time for deeper analyses.


```r
#combine cg_bigrams_united and stats_bigrams_united
#stop words have been removed
bigrams_united<-rbind(cg_bigrams_united, stats_bigrams_united)

bigram_tf_idf <- bigrams_united %>%
  count(group, bigram) %>%
  bind_tf_idf(bigram, group, n) %>%
  arrange(desc(tf_idf))

bigram_tf_idf
```

```
## # A tibble: 4,328 x 6
##    group bigram                    n      tf   idf  tf_idf
##    <chr> <chr>                 <int>   <dbl> <dbl>   <dbl>
##  1 stats time series              26 0.0116  0.693 0.00802
##  2 stats chi squared              13 0.00579 0.693 0.00401
##  3 stats statistics discussion    12 0.00534 0.693 0.00370
##  4 cg    climate crisis           15 0.00486 0.693 0.00337
##  5 stats linear regression        10 0.00445 0.693 0.00308
##  6 stats logistic regression      10 0.00445 0.693 0.00308
##  7 stats machine learning         10 0.00445 0.693 0.00308
##  8 stats mixed effects             9 0.00401 0.693 0.00278
##  9 stats squared test              9 0.00401 0.693 0.00278
## 10 cg    fight climate            11 0.00357 0.693 0.00247
## # … with 4,318 more rows
```


```r
#visualization
#fct_reorder(bigram, tf_dif) is the most classic argument here

bigram_tf_idf %>%
  group_by(group) %>%
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(bigram, tf_idf), fill = group)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~group, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />
It seems that the tf-idf approach is really effective in detecting the pattern in your text.


```r
#sentiment analysis
bigrams <- data %>%
  unnest_tokens(bigram, title, token = "ngrams", n = 2)

bigrams_separated <- bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

#negating words
bigrams_separated %>%
  filter(word1 == "not") %>%
  count(word1, word2, sort = TRUE)
```

```
## # A tibble: 44 x 3
##    word1 word2             n
##    <chr> <chr>         <int>
##  1 not   a                 2
##  2 not   be                2
##  3 not   so                2
##  4 not   sure              2
##  5 not   actually          1
##  6 not   always            1
##  7 not   appropriate       1
##  8 not   automatically     1
##  9 not   causation         1
## 10 not   coincidental      1
## # … with 34 more rows
```

```r
#AFINN
AFINN <- get_sentiments("afinn")
AFINN
```

```
## # A tibble: 2,477 x 2
##    word       value
##    <chr>      <dbl>
##  1 abandon       -2
##  2 abandoned     -2
##  3 abandons      -2
##  4 abducted      -2
##  5 abduction     -2
##  6 abductions    -2
##  7 abhor         -3
##  8 abhorred      -3
##  9 abhorrent     -3
## 10 abhors        -3
## # … with 2,467 more rows
```

```r
not_words <- bigrams_separated %>%
  filter(word1 == "not") %>%
  inner_join(AFINN, by = c(word2 = "word")) %>%
  count(word2, value, sort = TRUE)

#reorder(word2, contribution) is a classic argument here
not_words %>%
  mutate(contribution = n * value) %>%
  arrange(desc(abs(contribution))) %>%
  head(20) %>%
  mutate(word2 = reorder(word2, contribution)) %>%
  ggplot(aes(n * value, word2, fill = n * value > 0)) +
  geom_col(show.legend = FALSE) +
  labs(x = "Sentiment value * number of occurrences",
       y = "Words preceded by \"not\"")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r
#expanding negating words
negation_words <- c("not", "no", "never", "without")

negated_words <- bigrams_separated %>%
  filter(word1 %in% negation_words) %>%
  inner_join(AFINN, by = c(word2 = "word")) %>%
  count(word1, word2, value, sort = TRUE)

negated_words %>%
  mutate(contribution = abs(n * value)) %>%
  group_by(word1) %>% 
  arrange(desc(contribution), .by_group = T)
```

```
## # A tibble: 11 x 5
## # Groups:   word1 [2]
##    word1 word2       value     n contribution
##    <chr> <chr>       <dbl> <int>        <dbl>
##  1 no    good            3     1            3
##  2 no    luck            3     1            3
##  3 no    increase        1     1            1
##  4 no    matter          1     1            1
##  5 no    significant     1     1            1
##  6 not   fun             4     1            4
##  7 not   good            3     1            3
##  8 not   like            2     1            2
##  9 not   cutting        -1     1            1
## 10 not   expand          1     1            1
## 11 not   reaching        1     1            1
```

```r
negated_words %>%
  mutate(contribution = abs(n * value)) %>%
  mutate(word2 = reorder(word2, contribution)) %>%
  ggplot(aes(n * value, word2, fill = n * value > 0)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~word1, ncol = 2, scales = "free") +
  labs(x = "Sentiment value * number of occurrences",
       y = "Words preceded by negating words")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-2.png" width="672" />


```r
#visualizing a network of bigrams
#need to filter stop words
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

bigram_counts
```

```
## # A tibble: 4,319 x 3
##    word1      word2          n
##    <chr>      <chr>      <int>
##  1 climate    change       282
##  2 time       series        26
##  3 climate    crisis        15
##  4 chi        squared       13
##  5 statistics discussion    12
##  6 fight      climate       11
##  7 global     warming       11
##  8 heat       wave          11
##  9 linear     regression    10
## 10 logistic   regression    10
## # … with 4,309 more rows
```

```r
bigram_graph <- bigram_counts %>%
  filter(n > 4) %>%
  graph_from_data_frame()

bigram_graph
```

```
## IGRAPH 46b4f8d DN-- 68 49 -- 
## + attr: name (v/c), n (e/n)
## + edges from 46b4f8d (vertex names):
##  [1] climate    ->change       time       ->series      
##  [3] climate    ->crisis       chi        ->squared     
##  [5] statistics ->discussion   fight      ->climate     
##  [7] global     ->warming      heat       ->wave        
##  [9] linear     ->regression   logistic   ->regression  
## [11] machine    ->learning     co2        ->emissions   
## [13] mixed      ->effects      sea        ->level       
## [15] squared    ->test         carbon     ->capture     
## + ... omitted several edges
```

```r
set.seed(2017)
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

```r
set.seed(2020)
a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-2.png" width="672" />
