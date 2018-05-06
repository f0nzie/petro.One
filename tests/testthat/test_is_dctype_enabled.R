library(testthat)

context("is_dctype_enabled in summary.R")


test_that("is_dctype_enabled = TRUE", {
    my_url <- make_search_url(query = "mechanistic",
                              how = "all")
    page <- xml2::read_html(my_url)
    expect_true(petro.One:::is_dctype_enabled(page))


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")
    page <- xml2::read_html(my_url)
    expect_true(petro.One:::is_dctype_enabled(page))
})
