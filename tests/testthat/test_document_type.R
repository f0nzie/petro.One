library(testthat)

context("make_search_url at url.R")

test_that("document type = *journal-paper* matches", {
    my_url <- make_search_url(query = "neural network",
                              how = "all",
                              dc_type = "journal-paper",
                              rows = 1000)

    expect_equal(get_papers_count(my_url), 303, tolerance = 3)
})


test_that("document type = *conference-paper* matches", {
    my_url <- make_search_url(query = "neural network",
                              how = "all",
                              dc_type = "conference-paper",
                              rows = 1000)

    # expect_equal(get_papers_count(my_url), 2661, tolerance = 30)
    expect_equal(get_papers_count(my_url), 2687, tolerance = 30)
})
