library(testthat)

context("read_multidoc(), neural network, 1970-1987")
test_that("when read_multidoc gets zero rows", {
    my_url <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 1987,
                              how = "all")
    df <- read_multidoc(my_url)
    expect_equal(nrow(df), 0)
})


context("read_multidoc(), neural network, all")
test_that("when read_multidoc with neural network gets almost 3000 rows", {
    my_url <- make_search_url(query = "neural network",
                              how = "all")
    df <- read_multidoc(my_url)
    # cat(nrow(df))
    expect_gte(nrow(df), 3230)
})


context("read_multipage(), neural network by dc_type")

test_that("when read_multipage conference-paper", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "conference-paper",
                              how = "all")
    df <- read_multipage(my_url)
    expect_equal(nrow(df), 2881)
})

test_that("when read_multipage journal-paper", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "journal-paper",
                              how = "all")
    df <- read_multipage(my_url)
    expect_equal(nrow(df), 323)
})

test_that("when read_multipage presentation", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "presentation",
                              how = "all")
    df <- read_multipage(my_url)
    expect_equal(nrow(df), 23)
})

test_that("when read_multipage media", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "media",
                              how = "all")
    df <- read_multipage(my_url)
    expect_equal(nrow(df), 2)
})

test_that("when read_multipage standard type", {
    my_url <- make_search_url(query = "neural network",
                              dc_type = "standard",
                              how = "all")
    df <- read_multipage(my_url)
    expect_equal(nrow(df), 0)
})


context("test when the URL has rows > 1000")
test_that("", {
    top <- c("data driven")
    discipline <- c("reservoir", "production", "surface facilities", "metering")

    by.discipline.dd <- join_keywords(top, discipline,
                                      get_papers = TRUE, sleep = 3)
    recno <- 2
    my.sf <- by.discipline.dd$keywords$sf[recno]
    expect_equal(my.sf, "'data+driven'AND'production'")

})


