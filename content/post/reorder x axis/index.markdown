---
title: "reorder x axis"
output: html_document
draft: true
---




```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.2     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


```r
diamonds %>% 
  count(cut_width(carat, 0.5)) %>% 
  mutate(`cut_width(carat, 0.5)` = fct_reorder(`cut_width(carat, 0.5)`, desc(`cut_width(carat, 0.5)`))) %>% 
  ggplot(mapping=aes(x=`cut_width(carat, 0.5)`, y = n))+
  geom_bar(stat='identity')+
  coord_flip()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

}
