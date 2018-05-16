library(testthat)
#library(petro.One)

context("14000+ papers, join_keywords() on *analytics*")

major_02 <- c("analytics", "data analytics")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
major_02_res <- join_keywords(major_02, get_papers = TRUE,
                              sleep = 3,
                              verbose = TRUE)
# 1  1901 'data+driven'
# 2  1901 'data-driven'

# we get an error searching the word "analytics"
#   Error: `X4` contains unknown variables


# 1   483 'data+analytics'
# 2 14718 'analytics'
# Show Traceback
#
# Rerun with Debug
# Error: `X4` contains unknown variables

# page pages   rows  get_papers_count
#   13    15  12000             14718


# test #1
url <- make_search_url("analytics", how = "all")
webpage <- xml2::read_html(url)
expect_equal(get_papers_count(url), 14720)

# test #2
expect_equal(dim(petro.One:::get_dc_type_raw(webpage)), c(10, 7))


