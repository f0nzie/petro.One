library(testthat)
library(stubthat)

context("mock test of from_year to to_year")

check_search <- function(query, from_year, to_year, how) {
    response <- make_search_url(query = "neural network",
                                from_year = 1990,
                                to_year   = 2000,
                                how = "all")
    response_status <- 510
}


make_search_url_stub <- stub(make_search_url)

check_search_tester <- function(query, from_year, to_year, how) {
    mockr::with_mock(make_search_url = make_search_url_stub$f,
                     check_search(query, from_year, to_year, how))
}


expect_equal(check_search_tester(query = "neural network",
                                 from_year = 1990,
                                 to_year   = 2000,
                                 how = "all"), 510)
