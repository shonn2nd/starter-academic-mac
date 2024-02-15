# Create Dummy Variables

## Load Packages

    library(fastDummies)
    library(tidyverse)
    library(psych)

## Create a DataSet

    # Create a vector of race scores
    race <- c("White", "Black", "Asian", "Hispanic", "Other")

    # Generate random income values for each race (100 cases)
    set.seed(123) # for reproducibility
    income <- round(runif(100, min = 20000, max = 100000), digits = 2)

    # Repeat each race 20 times to get 100 cases
    race <- rep(race, each = 20)

    # Combine race and income into a data frame
    data <- data.frame(race, income)

    # Print the first few rows of the dataset
    print(head(data))

    ##    race   income
    ## 1 White 43006.20
    ## 2 White 83064.41
    ## 3 White 52718.15
    ## 4 White 90641.39
    ## 5 White 95237.38
    ## 6 White 23644.52

## Create Dummy Variables

    data<-data |> dummy_cols(select_columns = "race")

## Regress Race on Income (African Americans as the Reference Category)

    fit<-lm(income ~ race_Asian + race_Hispanic + race_Other + race_White, data=data)
    summary(fit)

    ## 
    ## Call:
    ## lm(formula = income ~ race_Asian + race_Hispanic + race_Other + 
    ##     race_White, data = data)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -44169 -19531  -1137  18010  40481 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)      66138       5066  13.055   <2e-16 ***
    ## race_Asian      -15015       7165  -2.096   0.0388 *  
    ## race_Hispanic    -7004       7165  -0.977   0.3308    
    ## race_Other       -7173       7165  -1.001   0.3193    
    ## race_White       -2073       7165  -0.289   0.7730    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 22660 on 95 degrees of freedom
    ## Multiple R-squared:  0.05237,    Adjusted R-squared:  0.01247 
    ## F-statistic: 1.313 on 4 and 95 DF,  p-value: 0.2709
