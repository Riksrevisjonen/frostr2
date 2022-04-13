
<!-- README.md is generated from README.Rmd. Please edit that file -->

# frostr2

<!-- badges: start -->

[![R-CMD-check](https://github.com/Riksrevisjonen/frostr2/workflows/R-CMD-check/badge.svg)](https://github.com/Riksrevisjonen/frostr2/actions)
[![Lifecycle:experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

frostr2 is an unofficial R client to MET Norway’s Frost API.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Riksrevisjonen/frostr2")
```

## Usage

### Initial setup

In order to use the Frost API you will need to register an account with
[MET Norway](https://frost.met.no/index.html). This will grant you a
client id and secret that you should store in a safe place.

To work with frostr2 it is recommended that you store the credentials as
a set of environmental variables (MET\_FROST\_ID and MET\_FROST\_SECRET)
available to R. You could either do this yourself or you could use the
helper function `set_frost_client()`. Must users will typically benefit
from setting environmental variables at the user level.

``` r
frostr2::set_frost_client(scope = "user") 
```

### Basic example

``` r
library(frostr2)

# Fetch observation data
df <- get_observations(
  sources = c("SN18700", "SN90450"),
  reference_time = "2010-04-01/2010-04-03",
  elements = c(
    "mean(air_temperature P1D)",
    "sum(precipitation_amount P1D)",
    "mean(wind_speed P1D)"
  )
)
head(df)
#> # A tibble: 6 x 12
#>   data.sourceId data.referenceTime       data.observations.ele~ data.observatio~
#>   <chr>         <chr>                    <chr>                             <dbl>
#> 1 SN18700:0     2010-04-01T00:00:00.000Z mean(air_temperature ~              3.2
#> 2 SN18700:0     2010-04-01T00:00:00.000Z mean(air_temperature ~              3  
#> 3 SN18700:0     2010-04-01T00:00:00.000Z sum(precipitation_amo~             13.5
#> 4 SN18700:0     2010-04-01T00:00:00.000Z sum(precipitation_amo~             29  
#> 5 SN18700:0     2010-04-01T00:00:00.000Z mean(wind_speed P1D)                1.7
#> 6 SN18700:0     2010-04-02T00:00:00.000Z mean(air_temperature ~              3  
#> # ... with 8 more variables: data.observations.unit <chr>,
#> #   data.observations.level <df[,3]>, data.observations.timeOffset <chr>,
#> #   data.observations.timeResolution <chr>,
#> #   data.observations.timeSeriesId <int>,
#> #   data.observations.performanceCategory <chr>,
#> #   data.observations.exposureCategory <chr>,
#> #   data.observations.qualityCode <int>
```

## For developers

For development purposes it is recommended to turn off the session based
caching. This can be done by setting the `FROSTR2_DISABLE_CACHING`
environmental variable to `"TRUE"`.

## Acknowledgments

frostr2 is inspired by [frostr](https://github.com/imangR/frostr) which
has developed by [Iman Ghayoornia](https://github.com/imangR).
