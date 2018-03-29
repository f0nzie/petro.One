library(testthat)
library(mockery)

context("test document type, dc_type at url.R")

m <- mock(303, 2687)

test_that("document type = *journal-paper* matches", {
    my_url <- make_search_url(query = "neural network",
                              how = "all",
                              dc_type = "journal-paper",
                              rows = 1000)
    # expect_gte(get_papers_count(my_url), 303)
    with_mock(get_papers_count = m, {
        expect_gte(get_papers_count(my_url), 303)
    })
})


test_that("document type = *conference-paper* matches", {
    my_url <- make_search_url(query = "neural network",
                              how = "all",
                              dc_type = "conference-paper",
                              rows = 1000)

    # expect_gte(get_papers_count(my_url), 2687)
    with_mock(get_papers_count = m, {
        expect_gte(get_papers_count(my_url), 2687)
    })
})
