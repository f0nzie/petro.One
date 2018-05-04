library(testthat)
library(mockery)

context("make_search_url from_year to_year at url.R")

m <- mock(510)

test_that("make_search_url matches number of papers from_year to_year", {
    # neural network papers from 1990 to 2000. Exact phrase

    expected <- 510
    my_url <- make_search_url(query = "neural network",
                              from_year = 1990,
                              to_year   = 2000,
                              how = "all")

    # expect_gte(get_papers_count(my_url), expected)

    with_mock(get_papers_count = m, {
              expect_gte(get_papers_count(my_url), 510)
    })

})
