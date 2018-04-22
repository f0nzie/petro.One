library(testthat)
library(mockery)

context("is_dctype_enabled in summary.R")

m <- mock(FALSE, FALSE, TRUE, TRUE)
test_loc <- system.file("testdata", package = "petro.One")

test_that("is_dctype_enabled = FALSE", {
my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
    page <- xml2::read_html(my_url)
    expect_false(petro.One:::is_dctype_enabled(page))
    with_mock(is_dctype_enabled = m, {
        expect_false(petro.One:::is_dctype_enabled(page))
    })


    my_url <- make_search_url(query = "bottomhole nodal",
                              how = "all")
    page <- xml2::read_html(my_url)
    # expect_false(petro.One:::is_dctype_enabled(page))
    with_mock(is_dctype_enabled = m, {
        expect_false(petro.One:::is_dctype_enabled(page))
    })
})

# test_that("is_dctype_enabled = TRUE", {
#     my_url <- make_search_url(query = "mechanistic",
#                               how = "all")
#     page <- xml2::read_html(my_url)
#     expect_true(petro.One:::is_dctype_enabled(page))
#
#
#     my_url <- make_search_url(query = "mechanistic performance",
#                               how = "any")
#     page <- xml2::read_html(my_url)
#     expect_true(petro.One:::is_dctype_enabled(page))
# })
