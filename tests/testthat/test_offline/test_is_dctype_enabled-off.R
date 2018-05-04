# offline unit test. using real data in HTML files
library(testthat)
library(mockery)

context("is_dctype_enabled in summary.R")



m <- mock(FALSE, FALSE)
test_loc <- system.file("testdata", package = "petro.One")

test_that("is_dctype_enabled = FALSE", {
my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")

    page.1 <- petro.One:::read_test_html("idcto_1.html")
    expect_false(petro.One:::is_dctype_enabled(page.1))
    # with_mock(is_dctype_enabled = m, {
    #     expect_false(petro.One:::is_dctype_enabled(page.1))
    # })


    my_url <- make_search_url(query = "bottomhole nodal",
                              how = "all")
    page.2 <- petro.One:::read_test_html("idcto_2.html")
    expect_false(petro.One:::is_dctype_enabled(page.2))
    # with_mock(is_dctype_enabled = m, {
    #     expect_false(petro.One:::is_dctype_enabled(page.2))
    # })
})

test_that("is_dctype_enabled = TRUE", {
    my_url <- make_search_url(query = "mechanistic",
                              how = "all")
    # page <- xml2::read_html(my_url)
    page.3 <- petro.One:::read_test_html("idcto_3.html")
    expect_true(petro.One:::is_dctype_enabled(page.3))


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")
    page.4 <- petro.One:::read_test_html("idcto_4.html")
    # page <- xml2::read_html(my_url)
    expect_true(petro.One:::is_dctype_enabled(page.4))
})
