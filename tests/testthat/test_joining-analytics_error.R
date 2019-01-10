# functions tested
#   join_keywords
#   get_papers_count
#   get_dc_type_raw

library(testthat)

skip_on_cran()
skip_on_travis()

context("apply join_keywords()")

major_03 <- c("data driven", "data analytics")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
test_that("returns correct number of papers #1", {
    keywords <- c("big data")
    result <- join_keywords(keywords, get_papers = TRUE,
                                  sleep = 3,
                                  verbose = FALSE)

    # page pages   rows  get_papers_count
    #   13    15  12000             14718
    expect_equal(dim(result$keywords), c(1,4))
    expect_equal(dim(result$papers), c(1222 , 7))

})

test_that("returns correct number of papers #", {
    keywords <- c("data science")
    result <- join_keywords(keywords, get_papers = TRUE,
                            sleep = 3,
                            verbose = FALSE)

    # page pages   rows  get_papers_count
    #   13    15  12000             14718
    expect_equal(dim(result$keywords), c(1,4))
    expect_equal(dim(result$papers), c(178 , 7))

})


context("check paper count for keywords")
test_that("paper count is correct, #1", {
    url <- make_search_url("big data", how = "all")
    webpage <- xml2::read_html(url)
    expect_equal(get_papers_count(url), 1222)
    expect_equal(dim(petro.One:::get_dc_type_raw(webpage)), c(10, 7))
})

test_that("paper count is correct, #2", {
    url <- make_search_url("data science", how = "all")
    webpage <- xml2::read_html(url)
    expect_equal(get_papers_count(url), 178)
    expect_equal(dim(petro.One:::get_dc_type_raw(webpage)), c(10, 3))
})


