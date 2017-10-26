
<!-- README.md is generated from README.Rmd. Please edit that file -->
petro.One
=========

[![Travis-CI Build Status](https://travis-ci.org/f0nzie/petro.One.svg?branch=master)](https://travis-ci.org/f0nzie/petro.One) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/petro.One)](https://cran.r-project.org/package=petro.One) [![codecov](https://codecov.io/gh/f0nzie/petro.One/branch/master/graph/badge.svg)](https://codecov.io/gh/f0nzie/petro.One)

The goal of **petro.One** is providing a reproducible platform for acquiring and analyzing metadata while searching papers on oil and gas in the OnePetro website.

Motivation
----------

The standard way of searching for papers in [OnePetro](https://www.onepetro.org/) is using a web browser to enter the search terms for a particular paper we are looking for. The result will come in web pages with which could be dozens, hundreds or thousand of paper titles. We will need to browse all the resulting pages to find papers that have a better match with the subject we are researching.

By using some statistical tools available through `R`, the search could turn in highly profitable in terms of time, matching quality and selection of the papers.

The search keywords are entered thorugh the R console and the papers will return in a shape of a dataframe, which is identical to a spreadsheet: rows of paper titles and columns with details from the metadata extracted from the web page.

With the dataframe already in our computers we could perform a thorough search and narrow down to the most ideal papers.

Installation
------------

You can install petro.One from github with:

``` r
# install.packages("devtools")
devtools::install_github("f0nzie/petro.One")
```

or from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("petro.One")
```

Get the number of papers for the keyword *neural network*.
----------------------------------------------------------

The option `how = "any"` means to search for papers that contain the word `neural` or the word `network`.

``` r
library(petro.One)

my_url <- make_search_url(query = "neural network", how = "any")
my_url
#> [1] "https://www.onepetro.org/search?q=neural+network&peer_reviewed=&published_between=&from_year=&to_year="
get_papers_count(my_url)
#> [1] 3335
```

Read papers from *from\_year* to *to\_year*
-------------------------------------------

We can send a query where we specify the starting years and the end year. Use the parameters as in the example below.

In this example the option `how = "all"` means to search papers that contain **exactly** the words `neural network`.

``` r
library(petro.One)

# neural network papers from 1990 to 2000. Exact phrase
my_url <- make_search_url(query = "neural network", 
                          from_year = 1990, 
                          to_year   = 1999, 
                          how = "all")

get_papers_count(my_url)
#> [1] 415
onepetro_page_to_dataframe(my_url)
#> # A tibble: 10 x 6
#>                                                      title_data
#>                                                           <chr>
#>  1                          Deconvolution Using Neural Networks
#>  2                     Neural Network Stacking Velocity Picking
#>  3     Conductive fracture identification using neural networks
#>  4 Reservoir Characterization Using Feedforward Neural Networks
#>  5          Seismic Attribute Calibration Using Neural Networks
#>  6        Neural Networks For Primary Reflection Identification
#>  7      Artificial Intelligence I Neural Networks In Geophysics
#>  8         Inversion of Seismic Waveforms Using Neural Networks
#>  9                    Neural Networks In the Petroleum Industry
#> 10             Neural Networks And Paper Seismic Interpretation
#> # ... with 5 more variables: paper_id <chr>, source <chr>, type <chr>,
#> #   year <int>, author1_data <chr>
```

Get papers by document type (*dc\_type*)
----------------------------------------

We can also get paper by the type of document. In this example we are requesting only "conference-paper" type.

``` r
# specify document type = "conference-paper", rows = 1000

my_url <- make_search_url(query = "neural network", 
                          how = "all",
                          dc_type = "conference-paper",
                          rows = 1000)

get_papers_count(my_url)
#> [1] 2706
onepetro_page_to_dataframe(my_url)
#> # A tibble: 1,000 x 6
#>                                                      title_data
#>                                                           <chr>
#>  1                                      Neural Networks And AVO
#>  2                          Deconvolution Using Neural Networks
#>  3                     Neural Network Stacking Velocity Picking
#>  4       Seismic Velocity Picking using Hopfield Neural Network
#>  5            AVO Inversion By Artificial Neural Networks (ANN)
#>  6     Conductive fracture identification using neural networks
#>  7 Reservoir Characterization Using Feedforward Neural Networks
#>  8          Seismic Attribute Calibration Using Neural Networks
#>  9        Neural Networks For Primary Reflection Identification
#> 10             Hydrocarbon Prediction Using Dual Neural Network
#> # ... with 990 more rows, and 5 more variables: paper_id <chr>,
#> #   source <chr>, type <chr>, year <int>, author1_data <chr>
```

In this other example we are requesting for "journal-paper" type of papers.

``` r
# specify document type = "journal-paper", rows = 1000

my_url <- make_search_url(query = "neural network", 
                          how = "all",
                          dc_type = "journal-paper",
                          rows = 1000)

get_papers_count(my_url)
#> [1] 306
onepetro_page_to_dataframe(my_url)
#> # A tibble: 306 x 6
#>                                                                     title_data
#>                                                                          <chr>
#>  1                   Implicit Approximation of Neural Network and Applications
#>  2                Artificial Neural Networks Identify Restimulation Candidates
#>  3                                    Drill-Bit Diagnosis With Neural Networks
#>  4 Characterize Submarine Channel Reservoirs: A Neural- Network-Based Approach
#>  5 Treating Uncertainties in Reservoir-Performance Prediction With Neural Netw
#>  6          An Artificial Neural Network Based Relative Permeability Predictor
#>  7                      Neural Network: What It Can Do for Petroleum Engineers
#>  8 Characterizing Partially Sealing Faults - An Artificial Neural Network Appr
#>  9                  Neural Network for Time-Lapse Seismic Reservoir Monitoring
#> 10                Neural Network Approach Predicts U.S. Natural Gas Production
#> # ... with 296 more rows, and 5 more variables: paper_id <chr>,
#> #   source <chr>, type <chr>, year <int>, author1_data <chr>
```

Summaries
---------

Here is an example of summaries. In this case, we want papers that contain the exact words "well test".

``` r
library(petro.One)

my_url <- make_search_url(query = "well test", 
                          how = "all")
```

``` r
papers_by_type(my_url)
```

### By document type

| name             |  value|
|:-----------------|------:|
| Chapter          |      8|
| Conference paper |   9378|
| General          |    193|
| Journal paper    |   2531|
| Media            |      5|
| Other            |      8|
| Presentation     |     25|

### By publisher

``` r
papers_by_publisher(my_url)
```

| name                                                  |  value|
|:------------------------------------------------------|------:|
| American Petroleum Institute                          |     42|
| American Rock Mechanics Association                   |     64|
| BHR Group                                             |     10|
| Carbon Management Technology Conference               |      1|
| International Petroleum Technology Conference         |    364|
| International Society for Rock Mechanics              |     39|
| International Society of Offshore and Polar Engineers |     15|
| NACE International                                    |     45|
| National Energy Technology Laboratory                 |      8|
| Offshore Mediterranean Conference                     |     44|

### By publication source

``` r
papers_by_publication(my_url)
```

| name                                                              |  value|
|:------------------------------------------------------------------|------:|
| 10th North American Conference on Multiphase Technology           |      1|
| 10th World Petroleum Congress                                     |      1|
| 11th ISRM Congress                                                |      1|
| 11th World Petroleum Congress                                     |      4|
| 12th ISRM Congress                                                |      1|
| 12th International Conference on Multiphase Production Technology |      2|
| 12th World Petroleum Congress                                     |      3|
| 13th ISRM International Congress of Rock Mechanics                |      1|
| 13th International Conference on Multiphase Production Technology |      1|
| 13th World Petroleum Congress                                     |      3|

### By year of publication

``` r
papers_by_year(my_url)
```

| name       |  value|
|:-----------|------:|
| Since 2017 |    429|
| Since 2016 |    995|
| Since 2015 |   1544|
| Since 2014 |   2101|
| Since 2013 |   2612|
| Since 2012 |   3126|
| Since 2011 |   3579|
| Since 2010 |   4105|
| Since 2009 |   4536|
| Since 2008 |   4947|

Search for **any** word
-----------------------

In this other example, we want papers that containg the word "well" or "test".

``` r
library(petro.One)

my_url <- make_search_url(query = "well test", 
                          how = "any")

by_doctype <- papers_by_type(my_url)
```

``` r
by_doctype
```

| name             |  value|
|:-----------------|------:|
| Chapter          |     60|
| Conference paper |  87045|
| General          |    932|
| Journal paper    |  15835|
| Media            |      9|
| Other            |     21|
| Presentation     |    265|
| Standard         |     95|

#### Total number of papers that contain **well** or **test**

``` r
sum(by_doctype$value)
#> [1] 104262
```
