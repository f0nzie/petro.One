library(testthat)
library(mockery)

context("onepetro_page_to_dataframe paper_to_dataframe.R")

test_save_loc  <- "./inst/testdata"
test_save_file <- paste(test_save_loc, "optd.rda", sep = "/")
test_load_loc  <- system.file("testdata", package = "petro.One")
test_load_file <- paste(test_load_loc, "optd.rda", sep = "/")



df <- data.frame(title_data = character(), paper_id = character(),
                        source = character(), type = character(), year = integer(),
                        author1_data = character())
m <- mock(df,
          names(df),
          dim(df)[1])

test_that("when returning no results, expect dataframe", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = TRUE)

    if (!file.exists(test_load_file)) {
        df <- onepetro_page_to_dataframe(my_url)
    } else {
        load(file = test_load_file)
        df <- test.df.1
    }

    expect_is(df, "data.frame")
    expect_true(all(names(df) == c("title_data", "paper_id", "source", "type", "year", "author1_data")))
    expect_equal(dim(df)[1], 0, tolerance = 1)

#     with_mock(df = m, {
#         expect_is(df, "data.frame")
#         expect_true(all(names(df) == c("title_data", "paper_id", "source", "type", "year", "author1_data")))
#         expect_equal(dim(df)[1], 0, tolerance = 1)
#     })

})


test_that("when returning some results, expect dataframe", {
    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = FALSE)

    if (!file.exists(test_load_file)) {
        df <- onepetro_page_to_dataframe(my_url)
    } else {
        load(file = test_load_file)
        df <- test.df.2
    }

    expect_is(df, "data.frame")
    expect_true(all(names(df) == c("title_data", "paper_id", "source", "type", "year", "author1_data")))
    expect_equal(dim(df)[1], 2, tolerance = 1)
})



