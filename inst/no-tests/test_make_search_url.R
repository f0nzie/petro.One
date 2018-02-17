library(testthat)

context("make_search_url with get_papers_count at url.R")

test_that("return no results", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                             how = "all", from_year = 2001, to_year = 2007,
                             peer_reviewed = TRUE)

    expect_equal(get_papers_count(my_url), 0, tolerance = 1)
})


test_that("return some results", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = FALSE)

    expect_equal(get_papers_count(my_url), 2, tolerance = 1)
})
