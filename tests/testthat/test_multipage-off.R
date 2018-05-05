library(testthat)
library(mockery)

test_load_loc  <- system.file("testdata", package = "petro.One")
test_load_file <- paste(test_load_loc, "mdoc_nn_by_year.rda", sep = "/")
load(test_load_file)



context("read_multidoc, offline")

m <- mock(0, 3090, 4)

test_that("when read_multidoc gets zero rows", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1987,
                              how = "all")
    # df <- read_multidoc(my_url)
    # expect_equal(nrow(df), 0)
    with_mock(nrow = m, {
        expect_equal(nrow(df), 0)
    })
})

# test_that("when read_multidoc gets almost 3000 rows", {
#     my_url <- make_search_url(query = "neural network",
#                               how = "all",
#                               dc_type = "conference-paper",
#                               rows = 1000)
#     df <- read_multidoc(my_url)
#     expect_gte(nrow(df), 2756)
# })

test_that("when read_multidoc with neural network gets almost 3000 rows", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multidoc(my_url)
    # expect_gte(nrow(df), 3090)

    with_mock(nrow = m, {
        expect_equal(nrow(df), 3090)
    })
})

test_that("when read_multidoc search mechanistic performance", {
    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    # df <- read_multidoc(my_url)
    # expect_gte(nrow(df), 4)

    with_mock(nrow = m, {
        expect_equal(nrow(df), 4)
    })
})



# important!!! provide the type of paper in this test
context("read_multipage providing one paper type at a time, offline")
m <- mock(4, 23, 0, 0)

# test_that("when read_multipage conference-paper gets almost 3000 rows", {
#     my_url <- make_search_url(query = "neural network",
#                               dc_type = "conference-paper",
#                               how = "all")
#     df <- read_multipage(my_url)
#     expect_gte(nrow(df), 2756)
# })

test_that("when read_multipage journal-paper gets almost 3000 rows", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "journal-paper",
                              how = "all")
    # df <- read_multipage(my_url)
    # expect_gte(nrow(df), 306)

    with_mock(nrow = m, {
        expect_equal(nrow(df), 4)
    })
})

test_that("when read_multipage presentation only", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "presentation",
                              how = "all")
    # df <- read_multipage(my_url)
    # expect_gte(nrow(df), 23)

    with_mock(nrow = m, {
        expect_equal(nrow(df), 23)
    })
})

test_that("when read_multipage media only", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "media",
                              how = "all")
    # df <- read_multipage(my_url)
    # expect_gte(nrow(df), 0)

    with_mock(nrow = m, {
        expect_equal(nrow(df), 0)
    })
})

test_that("when read_multipage standard type only", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "standard",
                              how = "all")
    # df <- read_multipage(my_url)
    # petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)

    with_mock(nrow = m, {
        petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)
    })
})



context("read_multipage providing the paper type, offline")

m <- mock(0, 0, 0, 306, 23)

test_that("when read_multipage journal-paper only", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multipage(my_url, doctype = "standard")
    # petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)

    with_mock(nrow = m, {
        petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)
    })
})

test_that("when read_multipage journal-paper only", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multipage(my_url, doctype = "media")
    # petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)

    with_mock(nrow = m, {
        petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)
    })
})

test_that("when read_multipage journal-paper only", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multipage(my_url, doctype = "other")
    # petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)

    with_mock(nrow = m, {
        petro.One:::expect_equal_scale(nrow(df), 0, tolerance_pct = 0.01)
    })
})

# test_that("when read_multipage journal-paper only", {
#     my_url <- make_search_url(query = "neural network",
#                               how = "all")
#     df <- read_multipage(my_url, doctype = "conference-paper")
#     expect_gte(nrow(df), 2756)
# })

test_that("when read_multipage journal-paper only", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multipage(my_url, doctype = "journal-paper")
    # expect_gte(nrow(df), 306)

    with_mock(nrow = m, {
        expect_gte(nrow(df), 306)
    })
})


test_that("when read_multipage has no dc_type or doctype", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    # df <- read_multipage(my_url, doctype = "presentation")
    # expect_gte(nrow(df), 23)

    with_mock(nrow = m, {
        expect_gte(nrow(df), 23)
    })

})



