# offline unit test. using real data in HTML files
# mock function: gen_is_dctype_enabled()

library(testthat)
library(mockery)

context("is_dctype_enabled=FALSE, offline")
test_that("is_dctype_enabled = FALSE", {
my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")

    page.1 <- petro.One:::read_test_html("idcto_1.html")
    expect_false(petro.One:::is_dctype_enabled(page.1))


    my_url <- make_search_url(query = "bottomhole nodal",
                              how = "all")
    page.2 <- petro.One:::read_test_html("idcto_2.html")
    expect_false(petro.One:::is_dctype_enabled(page.2))
})

context("is_dctype_enabled=TRUE,  offline")
test_that("is_dctype_enabled = TRUE", {
    my_url <- make_search_url(query = "mechanistic",
                              how = "all")
    page.3 <- petro.One:::read_test_html("idcto_3.html")
    expect_true(petro.One:::is_dctype_enabled(page.3))


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")
    page.4 <- petro.One:::read_test_html("idcto_4.html")
    expect_true(petro.One:::is_dctype_enabled(page.4))
})
