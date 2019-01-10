# test functions
#   join_keywords()
#
# Functionality:
#   * list objects; keywords, papers dataframes

library(testthat)

skip_on_cran()
skip_on_travis()

context("join_keywords, test keywords and papers dataframes")

test_that("both dataframes return rows - test #5", {
    # provide two different set of keywords to combine as vectors
    major   <- c("waterflooding")
    minor   <- c("machine-learning", "artificial intelligence")
    lesser  <- c("algorithm")
    another <- c("data-mining")
    more    <- c("data-driven")

    p.df <- join_keywords(major, minor, lesser, another, more, get_papers = TRUE,
                          sleep = 2, verbose = FALSE)

    expect_equal(dim(p.df$keywords)[1], 2)         # number of rows
    expect_equal(nrow(p.df$papers)[1], 31)
    expect_equal(p.df$keywords$paper_count[1], 18)
    expect_equal(p.df$keywords$paper_count[2], 13)
})


context("join_keywords(), keywords dataframe, paper count on rows match")
test_that("both dataframes return rows - test #3", {
    # provide two different set of keywords to combine as vectors
    major  <- c("water-injection", "water injection")
    minor  <- c("machine-learning", "machine learning")
    lesser <- c("algorithm")

    p.df <- join_keywords(major, minor, lesser, get_papers = TRUE,
                          sleep = 2, verbose = FALSE)

    expect_equal(dim(p.df$keywords)[1], 4)   # number of rows
    expect_equal(dim(p.df$papers)[1], 544)
    # comparing paper count
    expect_equal(p.df$keywords$paper_count[1], 136)
    expect_equal(p.df$keywords$paper_count[2], 136)
    expect_equal(p.df$keywords$paper_count[3], 136)
    expect_equal(p.df$keywords$paper_count[4], 136)
    expect_equal(p.df$keywords$paper_count[1], p.df$keywords$paper_count[2])
    expect_equal(p.df$keywords$paper_count[3], p.df$keywords$paper_count[4])

})
