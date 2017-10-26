library(testthat)

context("onepetro_page_to_dataframe paper_to_dataframe.R")

test_that("when returning no results, expect dataframe", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = TRUE)
    df <- onepetro_page_to_dataframe(my_url)
    expect_is(df, "data.frame")
    expect_true(all(names(df) == c("title_data", "paper_id", "source", "type", "year", "author1_data")))
    expect_equal(dim(df)[1], 0, tolerance = 1)
})


test_that("when returning some results, expect dataframe", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = FALSE)
    df <- onepetro_page_to_dataframe(my_url)
    expect_is(df, "data.frame")
    expect_true(all(names(df) == c("title_data", "paper_id", "source", "type", "year", "author1_data")))
    expect_equal(dim(df)[1], 2, tolerance = 1)
})
