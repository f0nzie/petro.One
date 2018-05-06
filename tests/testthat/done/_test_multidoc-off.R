library(testthat)
library(mockery)

test_load_loc  <- system.file("testdata", package = "petro.One")
test_load_file <- paste(test_load_loc, "mdoc_nn_by_year.rda", sep = "/")
load(test_load_file)


context("read_multidoc(), Neural Networks by year, offline")

test_that("NN papers from 1970 to 1987 are 0", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1987,
                              how = "all")

    m <- mock(nn_by_year$y7087)
    with_mock(read_multidoc = m, {
        df <- read_multidoc(my_url)
        expect_equal(nrow(df), 0)
    })
})

test_that("NN papers from 1970 to 1988 are 1", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1988,
                              how = "all")

    m <- mock(nn_by_year$y7088)
    with_mock(read_multidoc = m, {
        df <- read_multidoc(my_url)
        expect_equal(nrow(df), 1)   # 02 by OnePetro
    })
})

test_that("NN papers from 1970 to 1990 are 17", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1990,
                              how = "all")

    m <- mock(nn_by_year$y7090)
    with_mock(read_multidoc = m, {
        df <- read_multidoc(my_url)
        expect_equal(nrow(df), 17)   # 19 by OnePetro
    })
})

test_that("NN papers from 1970 to 1995 are 159", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1995,
                              how = "all")

    m <- mock(nn_by_year$y7095)
    with_mock(read_multidoc = m, {
        df <- read_multidoc(my_url)
        expect_equal(nrow(df), 159)   # 172 by OnePetro
    })
})

test_that("NN papers from 1970 to 2000 are 517", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 2000,
                              how = "all")

    m <- mock(nn_by_year$y7020)
    with_mock(read_multidoc = m, {
        df <- read_multidoc(my_url)
        expect_equal(nrow(df), 517)    # 561 by OnePetro
    })
})

