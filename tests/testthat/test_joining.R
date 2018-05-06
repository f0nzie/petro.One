library(testthat)

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

    expect_true(dim(p.df$keywords)[1] == 2)         # number of rows
    expect_true(nrow(p.df$papers)[1] == 26)
    expect_true(p.df$keywords$paper_count[1] == 15)
    expect_true(p.df$keywords$paper_count[2] == 11)
})


context("join_keywords(), keywords dataframe, paper count on rows match")
test_that("both dataframes return rows - test #3", {
    # provide two different set of keywords to combine as vectors
    major  <- c("water-injection", "water injection")
    minor  <- c("machine-learning", "machine learning")
    lesser <- c("algorithm")

    p.df <- join_keywords(major, minor, lesser, get_papers = TRUE,
                          sleep = 2, verbose = FALSE)

    expect_true(dim(p.df$keywords)[1] == 4)   # number of rows
    expect_true(dim(p.df$papers)[1] == 460)
    # comparing paper count
    expect_equal(p.df$keywords$paper_count[1], 115)
    expect_equal(p.df$keywords$paper_count[2], 115)
    expect_equal(p.df$keywords$paper_count[3], 115)
    expect_equal(p.df$keywords$paper_count[4], 115)
    expect_equal(p.df$keywords$paper_count[1], p.df$keywords$paper_count[2])
    expect_equal(p.df$keywords$paper_count[3], p.df$keywords$paper_count[4])

})
