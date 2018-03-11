library(testthat)
library(stubthat)

# context("make_search_url from_year to_year at url.R")
#
# test_that("make_search_url matches number of papers from_year to_year", {
#     # Duration: 4.8 s
#     # neural network papers from 1990 to 2000. Exact phrase
#     expected <- 510
#     my_url <- make_search_url(query = "neural network",
#                               from_year = 1990,
#                               to_year   = 2000,
#                               how = "all")
#     expect_gte(get_papers_count(my_url), expected)
#
# })


check_search <- function(query, from_year, to_year, how) {
    response <- make_search_url(query = "neural network",
                                from_year = 1990,
                                to_year   = 2000,
                                how = "all")
    response_status <- 510
}


make_search_url_stub <- stub(make_search_url)

# make_search_url_stub$withArgs(query = "neural network",
#                                       from_year = 1990,
#                                       to_year   = 2000,
#                                       how = "all")$returns(510)


check_search_tester <- function(query, from_year, to_year, how) {
    mockr::with_mock(make_search_url = make_search_url_stub$f,
                     check_search(query, from_year, to_year, how))
}


expect_equal(check_search_tester(query = "neural network",
                                 from_year = 1990,
                                 to_year   = 2000,
                                 how = "all"), 510)
