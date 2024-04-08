Please check McNeish ([2018](#ref-mcneish2018)) for details. Here, I am
using the NSCH dataset as an example.

    #load packages
    library(haven)
    library(tidyverse)
    library(userfriendlyscience)

    #import data
    data<-read_sav("nsch.sav")

    #clear the current graphics frame and get ready for the next plot
    plot.new()

![](index_files/figure-markdown_strict/unnamed-chunk-3-1.png)

    #the answer
    data %>% 
      filter(across(c(RECOGBEGIN, CLEAREXP, WRITENAME, RECSHAPES), ~ . < 6)) %>% 
      select(RECOGBEGIN, CLEAREXP, WRITENAME, RECSHAPES) %>% 
      scaleStructure()

    ## 
    ## Information about this analysis:
    ## 
    ##                  Dataframe: .
    ##                      Items: all
    ##               Observations: 11648
    ##      Positive correlations: 6 out of 6 (100%)
    ## 
    ## Estimates assuming interval level:
    ## 
    ##              Omega (total): 0.71
    ##       Omega (hierarchical): 0.72
    ##    Revelle's omega (total): 0.75
    ## Greatest Lower Bound (GLB): 0.73
    ##              Coefficient H: 0.74
    ##           Cronbach's alpha: 0.7
    ## Confidence intervals:
    ##              Omega (total): [0.71, 0.72]
    ##           Cronbach's alpha: [0.69, 0.71]
    ## 
    ## Estimates assuming ordinal level:
    ## 
    ##      Ordinal Omega (total): 0.8
    ##  Ordinal Omega (hierarch.): 0.8
    ##   Ordinal Cronbach's alpha: 0.8
    ## Confidence intervals:
    ##      Ordinal Omega (total): [0.8, 0.81]
    ##   Ordinal Cronbach's alpha: [0.8, 0.81]
    ## 
    ## Note: the normal point estimate and confidence interval for omega are based on the procedure suggested by Dunn, Baguley & Brunsden (2013) using the MBESS function ci.reliability, whereas the psych package point estimate was suggested in Revelle & Zinbarg (2008). See the help ('?scaleStructure') for more information.

**References**

McNeish, D. (2018). Thanks coefficient alpha, we’ll take it from here.
*Psychological Methods*, *23*(3), 412–433.
<https://doi.org/10.1037/met0000144>
