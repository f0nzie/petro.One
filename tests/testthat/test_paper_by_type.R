# Functions tested
#   make_search_url
#   papers_by_type
#   extract_source_when_disabled
#   get_item_source

library(testthat)

context("papers_by_type")

test_that("mechanistic performance, all, returns one row", {

    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")

    df <- (papers_by_type(my_url))

    expect_equal(df$name, "Journal Paper")
    expect_gte(sum(df$value), 4)
})


test_that("mechanistic performance, any, returns one row", {

    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")

    df <- (papers_by_type(my_url))

    expect_gte(sum(df$value), 3301)
})


context("extract_source_when_disabled")

test_that("search returns 0 papers", {

    my_url <- make_search_url(query = "IPR viscosity",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 0)
})

test_that("search returns 1 papers", {

    my_url <- make_search_url(query = "IPR neural",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 1)
})


test_that("search returns 1 papers", {

    my_url <- make_search_url(query = "VLP neural",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 0)
})


test_that("search returns 1 papers", {

    my_url <- make_search_url(query = "VLP Prosper",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 1)
})


test_that("search returns 2 papers", {

    my_url <- make_search_url(query = "IPR Prosper",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 2)
})



test_that("search returns 1 papers", {

    my_url <- make_search_url(query = "IPR VLP THP",
                              how = "all")

    page <- xml2::read_html(my_url)
    item_source <- petro.One:::get_item_source(page)
    item_source <- trimws(gsub("\n", "",item_source))
    df <- petro.One:::extract_source_when_disabled(item_source)
    expect_equal(nrow(df), 0)
})
