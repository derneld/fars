
# fars

The goal of fars is to simplify the processing and visualization of
Fatality Analysis Reporting System (FARS) data from the National Highway
Traffic Safety Administration.

## Installation

You can install the development version of fars from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("derneld/fars")
```

## Date Source

This package uses data from the NHTSA FARS, which contains a census of
fatal motor vehicle traffic crashes within the 50 States, the District
of Columbia, and Puerto Rico. Sample data for the years 2013, 2014, and
2015 are included in the package.

## Example

This is a basic example showing how to summarize fatalities by month and
year:

``` r
library(fars)

# Summarize multiple years of data
fars_summarize_years(c(2013, 2014, 2015))
#> # A tibble: 12 × 4
#>    MONTH `2013` `2014` `2015`
#>    <dbl>  <int>  <int>  <int>
#>  1     1   2230   2168   2368
#>  2     2   1952   1893   1968
#>  3     3   2356   2245   2385
#>  4     4   2300   2308   2430
#>  5     5   2532   2596   2847
#>  6     6   2692   2583   2765
#>  7     7   2660   2696   2998
#>  8     8   2899   2800   3016
#>  9     9   2741   2618   2865
#> 10    10   2768   2831   3019
#> 11    11   2615   2714   2724
#> 12    12   2457   2604   2781
```

You can also visualize fatalities on a state-wide map. For example, to
view fatalities in State ID 1 (Alabama) for the year 2013:

``` r
# Plot fatalities for a specific state and year
fars_map_state(1, 2013)
```

<img src="man/figures/README-exampe-1.png" alt="" width="100%" />

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

\##Package Overview The package provides three main exported functions:

- `fars_read_years()`: Efficiently reads multiple FARS data files.
- `fars_summarize_years()`: Produces a monthly summary table across
  years.
- `fars_map_state()`: Draws a map of accident locations for a given
  state.
