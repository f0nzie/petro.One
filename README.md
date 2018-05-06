
<!-- README.md is generated from README.Rmd. Please edit that file -->
petro.One
=========

[![Travis-CI Build Status](https://travis-ci.org/f0nzie/petro.One.svg?branch=master)](https://travis-ci.org/f0nzie/petro.One) [![codecov](https://codecov.io/gh/f0nzie/petro.One/branch/master/graph/badge.svg)](https://codecov.io/gh/f0nzie/petro.One)

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
# install.packages("devtools")       # install *devtools* first

# install from the *master* release branch
devtools::install_github("f0nzie/petro.One")
```

``` r
# install from the *develop* branch
devtools::install_github("f0nzie/petro.One", ref = "develop")
```

or from [CRAN](https://cran.r-project.org/) with:

``` r
install.packages("petro.One")
```

What is behind the paper search
-------------------------------

A typical OnePetro search URL would look like this:

        https://www.onepetro.org/search?q=neural+network&peer_reviewed=&published_between=&from_year=&to_year=
        

which could be explained like this:

`domain`: <https://www.onepetro.org/>
`command`: search?
`q=`: *parameter* that holds the query words. In the example above, it would be `q=neural+network`. As it is shown, it means search `any` word.
`peer_reviewed=`: *parameter* switch to get papers than have been only peer reviewed. When it has the value `on` means that is activated.
`published_between=`: *parameter* switch that activates when `from_year` and `to_year` have numeric entries.
`from_year=`: *parameter* to enter the starting year of the search
`to_year=`: *parameter* to enter the end year of the search.

There are additional parameters such as:

`start=`: *parameter* to indicate the starting page if the resulting search has several pages. `rows=`: *parameter* to indicate the number of rows (papers) to display per page. In the web browser, the options are 10, 50 and 100. Off-browser it could be a number up to 1000.
`sort=`: *parameter* related to the selector `Sort By` with options `Relevance`, `Most recent` and `Highest rated`.
`dc_type`: *parameter* that indicates what type of document the paper is. These are the type of documents:

    chapter
    conference-paper
    general
    journal-paper
    presentation
    media
    other
    standard

There are few additional parameters but they will not be used as often as the ones already described.

They key is build a search URL that is recognizable by OnePetro. To do that I wrote a function `make_search_url` that does just that. Instead of entering the search keywords, how will they be searched, year and type of paper, we enter them from the R console.

Below some examples:

Get the number of papers for the keyword *neural network*.
----------------------------------------------------------

The option `how = "any"` means to search for papers that contain the word `neural` or the word `network`.

Let's take a look at the difference in returning results with `any` and `all` for the same keywords `neural network`.

Here we make of of two functions of petro.One: `make_search_url` and `get_papers_count`.

``` r
library(petro.One)
# search any word like "neural" or "network"
url_any <- make_search_url(query = "neural network", how = "any")
url_any
#> [1] "https://www.onepetro.org/search?q=neural+network&peer_reviewed=&published_between=&from_year=&to_year="
get_papers_count(url_any)
#> [1] 3536

# search for papers that have "neural" and "network" at the same time
url_all <- make_search_url(query = "neural network", how = "all")
url_all
#> [1] "https://www.onepetro.org/search?q=\"neural+network\"&peer_reviewed=&published_between=&from_year=&to_year="
get_papers_count(url_all)
#> [1] 3238
```

Read papers from *from\_year* to *to\_year*
-------------------------------------------

We can send a query where we specify the starting year and the end year. Use the parameters as in the example below.

In this example the option `how = "all"` means to search papers that contain **exactly** the words `neural network` as a difference to `any` which means search for `any` occurrence of the words. Of course, using `any` rather than `all` will yield many more results.

We use two petro.One functions: `make_search_url` to build the OnePetro search URL and `onepetro_page_to_dataframe` to put the papers in a table.

``` r
library(petro.One)

# neural network papers from 1990 to 2000. Exact phrase
my_url <- make_search_url(query = "neural network", 
                          from_year = 1990, 
                          to_year   = 1999, 
                          how = "all")

df <- onepetro_page_to_dataframe(my_url)
df
#> # A tibble: 10 x 6
#>    book_title      paper_id  dc_type authors                   year source
#>    <fct>           <fct>     <fct>   <chr>                    <int> <fct> 
#>  1 Deconvolution ~ SEG-1996~ confer~ Essenreiter, Robert, Ka~  1996 SEG   
#>  2 Neural Network~ SEG-1992~ confer~ Schmidt, Jumndyr, Petro~  1992 SEG   
#>  3 First Break Pi~ SEG-1990~ confer~ Wagner, D.E., Amoco Pro~  1990 SEG   
#>  4 Neural Network~ SEG-1995~ confer~ Leggett, Miles, British~  1995 SEG   
#>  5 Seismic Princi~ SEG-1996~ confer~ Huang, Kou-Yuan, Nation~  1996 SEG   
#>  6 Drill-Bit Diag~ SPE-1955~ journa~ Arehart, R.A., Exxon Pr~  1990 SPE   
#>  7 Artificial Int~ SEG-1992~ confer~ Guo, Yi, Center for Pot~  1992 SEG   
#>  8 Inversion of S~ SEG-1992~ confer~ Ro&uml;th, Gunter, Inst~  1992 SEG   
#>  9 Neural Network~ SEG-1991~ confer~ McCormack, Michael P., ~  1991 SEG   
#> 10 Reservoir Char~ SEG-1993~ confer~ An, P., University of M~  1993 SEG
```

And these are the terms that repeat more freqently:

``` r
term_frequency(df)
#> # A tibble: 26 x 2
#>    word              freq
#>    <chr>            <int>
#>  1 neural              10
#>  2 networks             9
#>  3 seismic              3
#>  4 picking              2
#>  5 analysis             1
#>  6 artificial           1
#>  7 break                1
#>  8 characterization     1
#>  9 components           1
#> 10 deconvolution        1
#> # ... with 16 more rows
```

Get papers by document type (*dc\_type*)
----------------------------------------

We can also get paper by the type of document. In OnePetro it is called `dc_type`.

#### Conference papers (`conference-paper`)

In this example we are requesting only `conference-paper` type.

Here we add to `make_search_url` the parameter `dc_type`.

Note also that we are adding another parameter `rows` to get 1000 rows instead of 10, 50 or 100 as the browser allows.

``` r
# specify document type = "conference-paper", rows = 1000

my_url <- make_search_url(query = "neural network", 
                          how = "all",
                          dc_type = "conference-paper",
                          rows = 1000)

get_papers_count(my_url)
#> [1] 3238
df <- onepetro_page_to_dataframe(my_url)
df
#> # A tibble: 1,000 x 6
#>    book_title       paper_id  dc_type authors                  year source
#>    <fct>            <fct>     <fct>   <chr>                   <int> <fct> 
#>  1 Deconvolution U~ SEG-1996~ confer~ Essenreiter, Robert, K~  1996 SEG   
#>  2 Neural Networks~ SEG-2002~ confer~ Russell, Brian, Hampso~  2002 SEG   
#>  3 Neural Network ~ SEG-1992~ confer~ Schmidt, Jumndyr, Petr~  1992 SEG   
#>  4 First Break Pic~ SEG-1990~ confer~ Wagner, D.E., Amoco Pr~  1990 SEG   
#>  5 Neural Networks~ SEG-1995~ confer~ Leggett, Miles, Britis~  1995 SEG   
#>  6 Seismic Velocit~ SEG-2015~ confer~ Huang, Kou-Yuan, Natio~  2015 SEG   
#>  7 Estimation of W~ ISOPE-I-~ confer~ Okumoto, Yasuhisa, Kin~  2008 ISOPE 
#>  8 Seismic Princip~ SEG-1996~ confer~ Huang, Kou-Yuan, Natio~  1996 SEG   
#>  9 Dynamic Neural ~ SPE-8438~ confer~ Schultz, R.L., Hallibu~  2003 SPE   
#> 10 Minimum-varianc~ SEG-1988~ confer~ Zhao, Xiaofeng, Univer~  1988 SEG   
#> # ... with 990 more rows
```

#### Word cloud for journal papers

``` r
plot_wordcloud(df, max.words = 100, min.freq = 10)
```

![](man/figures/README-unnamed-chunk-7-1.png)

#### Journal papers (`journal-paper`)

In this other example we are requesting for `journal-paper` type of papers. We are also specifying to get the maximum number of rows that OnePetro permits per page: 1000. Of course, this value is not shown in the rows by page selector which maxes out at 100. It is understandable because loading 1000-row page would take too long.

``` r
# specify document type = "journal-paper", rows = 1000

my_url <- make_search_url(query = "neural network", 
                          how = "all",
                          dc_type = "journal-paper",
                          rows = 1000)

get_papers_count(my_url)
#> [1] 3238
df <- onepetro_page_to_dataframe(my_url)
df
#> # A tibble: 323 x 6
#>    book_title       paper_id  dc_type  authors                 year source
#>    <fct>            <fct>     <fct>    <chr>                  <int> <fct> 
#>  1 Implicit Approx~ SPE-1143~ journal~ Li, Dao-lun, Universi~  2009 SPE   
#>  2 Artificial Neur~ SPE-0200~ journal~ Denney, Dennis, JPT T~  2000 SPE   
#>  3 Drill-Bit Diagn~ SPE-1955~ journal~ Arehart, R.A., Exxon ~  1990 SPE   
#>  4 Application of ~ SPE-2542~ journal~ Nazi, G.M., Williams ~  1994 SPE   
#>  5 Neural Network ~ SPE-8241~ journal~ Al-Fattah, S.M., Saud~  2003 SPE   
#>  6 Neural Networks~ SPE-1099~ journal~ Denney, Dennis, JPT T~  1999 SPE   
#>  7 Characterize Su~ SPE-0802~ journal~ Denney, Dennis, JPT T~  2002 SPE   
#>  8 Pseudodensity L~ SPE-0517~ journal~ Carpenter, Chris, JPT~  2017 SPE   
#>  9 Application of ~ SPE-1234~ journal~ Hegeman, Peter S., Sc~  2009 SPE   
#> 10 An Artificial N~ PETSOC-0~ journal~ Guler, B., Dell Compu~  2003 PETSOC
#> # ... with 313 more rows
```

#### Word cloud for journal papers

``` r
plot_wordcloud(df, max.words = 100, min.freq = 50)
```

![](man/figures/README-unnamed-chunk-9-1.png)

Finding the most freqent terms in *well test*
---------------------------------------------

For this example we want to know about conference papers where the words *well* and *test* are found together in the papers.

``` r
library(petro.One)

my_url <- make_search_url(query = "well test", 
                          dc_type = "conference-paper",
                          how = "all")

get_papers_count(my_url)
#> [1] 9654
df <- read_multidoc(my_url)

term_frequency(df)
#> # A tibble: 9,973 x 2
#>    word        freq
#>    <chr>      <int>
#>  1 reservoir   1861
#>  2 well        1705
#>  3 gas         1477
#>  4 field       1323
#>  5 production  1127
#>  6 analysis    1063
#>  7 pressure     958
#>  8 reservoirs   915
#>  9 wells        901
#> 10 data         839
#> # ... with 9,963 more rows
```

#### Most frequent terms in *well test*

``` r
# plot the 500 most freqent terms
plot_bars(df, min.freq = 400)
```

![](man/figures/README-unnamed-chunk-11-1.png)

How do the most frequent terms relate each other
------------------------------------------------

Now, it is not enough for us to know what terms are the more repeating but how those freqent terms relate to each other.

In the following plot you will see that the strength of the relationship between terms is reflected by the thickness of the connection lines.

``` r
plot_relationships(df, min.freq = 400, threshold = 0.075)
```

![](man/figures/README-unnamed-chunk-12-1.png)

We can see that *wells* and *well* are connected strongly to *horizontal*, *transient*, *pressure*, *flow*, *testing*, *reservoirs*, *fracture*, and *analysis*. The rest of the words are frequent but not very much connected.

For instance, if you are looking for papers that have stronger relationship between *well test* and *permeability*, it would wise to add that term to the search.

``` r
library(petro.One)

my_url <- make_search_url(query = "well test permeability", 
                          dc_type = "conference-paper",
                          how = "all")

get_papers_count(my_url)
#> [1] 194
df <- read_multidoc(my_url)

term_frequency(df)
#> # A tibble: 716 x 2
#>    word          freq
#>    <chr>        <int>
#>  1 reservoir       87
#>  2 permeability    43
#>  3 well            38
#>  4 carbonate       33
#>  5 field           33
#>  6 fractured       27
#>  7 modeling        22
#>  8 integrated      21
#>  9 data            20
#> 10 reservoirs      20
#> # ... with 706 more rows
plot_bars(df, min.freq = 10)
```

![](man/figures/README-unnamed-chunk-13-1.png)

In this example, we can see the effect of refining our search by including the term *permeability*.

``` r
plot_relationships(df, min.freq = 15, threshold = 0.05)
```

![](man/figures/README-unnamed-chunk-14-1.png)

This has the advantage of improving the search and narrow down the papers we are more interested in.

Summaries
---------

The summary functions allow us to group the papers by a preferred group:

-   by type of document
-   by publisher
-   by publication
-   by year

This will give you a summary of the count not the papers themselves.

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
| Conference paper |   9654|
| General          |    193|
| Journal paper    |   2568|
| Media            |      5|
| Other            |      8|
| Presentation     |     25|

### By publisher

``` r
papers_by_publisher(my_url)
```

| name                                                          |  value|
|:--------------------------------------------------------------|------:|
| American Petroleum Institute                                  |     42|
| American Rock Mechanics Association                           |     64|
| BHR Group                                                     |     13|
| Carbon Management Technology Conference                       |      1|
| International Petroleum Technology Conference                 |    364|
| International Society for Rock Mechanics and Rock Engineering |     39|
| International Society of Offshore and Polar Engineers         |     15|
| NACE International                                            |     45|
| National Energy Technology Laboratory                         |      8|
| Offshore Mediterranean Conference                             |     44|

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
| Since 2018 |    120|
| Since 2017 |    726|
| Since 2016 |   1291|
| Since 2015 |   1840|
| Since 2014 |   2399|
| Since 2013 |   2910|
| Since 2012 |   3424|
| Since 2011 |   3877|
| Since 2010 |   4404|
| Since 2009 |   4836|

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
| Conference paper |  89805|
| General          |    936|
| Journal paper    |  16116|
| Media            |     10|
| Other            |     21|
| Presentation     |    265|
| Standard         |     95|

#### Total number of papers that contain **well** or **test**

In this example we get the total number of papers by document type.

``` r
sum(by_doctype$value)
#> [1] 107308
```

Or use the R base function `summary` to give us a quick statistics of the papers:

``` r
# r-base function summary
summary(by_doctype)
#>      name               value         
#>  Length:8           Min.   :   10.00  
#>  Class :character   1st Qu.:   50.25  
#>  Mode  :character   Median :  180.00  
#>                     Mean   :13413.50  
#>                     3rd Qu.: 4731.00  
#>                     Max.   :89805.00
```
