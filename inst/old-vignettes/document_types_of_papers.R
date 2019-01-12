## ------------------------------------------------------------------------
library(petro.One)

my_url <- make_search_url(query = "well test", 
                          how = "all")          # exact match

get_papers_count(my_url)

## ------------------------------------------------------------------------
sdc <- papers_by_type(my_url)
sdc

## ------------------------------------------------------------------------
library(petro.One)

my_url <- make_search_url(query = "smart completion", 
                          how = "all")          # exact match

sdc    <- papers_by_type(my_url)
sdc

## ------------------------------------------------------------------------
library(petro.One)

my_url <- make_search_url(query = "deepwater")

sdc    <- papers_by_type(my_url)
sdc

