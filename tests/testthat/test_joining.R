library(testthat)

test_that("both dataframes return rows - test #5", {
    # provide two different set of keywords to combine as vectors
    major   <- c("waterflooding")
    minor   <- c("machine-learning", "artificial intelligence")
    lesser  <- c("algorithm")
    another <- c("data-mining")
    more    <- c("data-driven")

    expect_equal(more, "data-driven")

    p.df <- join_keywords(major, minor, lesser, another, more, get_papers = TRUE,
                          sleep = 2, verbose = FALSE)
    # print(p.df$keywords)
    # print(p.df$papers)
    # print(dim(p.df$keywords)[1])
    expect_true(p.df$keywords$paper_count[1] >= 14)
    expect_true(dim(p.df$keywords)[1] >= 2)   # number of rows
    # expect_true(dim(p.df$papers)[1] >= 24)
})


test_that("both dataframes return rows - test #3", {
    # provide two different set of keywords to combine as vectors
    major  <- c("water-injection", "water injection")
    minor  <- c("machine-learning", "machine learning")
    lesser <- c("algorithm")

    expect_equal(lesser, "algorithm")

    p.df <- join_keywords(major, minor, lesser, get_papers = TRUE,
                          sleep = 2, verbose = FALSE)

    # print(p.df$keywords$paper_count[1])
    # print(dim(p.df$keywords)[1])
    # print(dim(p.df$papers)[1])
    expect_equal(p.df$keywords$paper_count[1], p.df$keywords$paper_count[2])
    expect_equal(p.df$keywords$paper_count[3], p.df$keywords$paper_count[4])
    expect_true(dim(p.df$keywords)[1] >= 4)  # number of rows
    # expect_true(dim(p.df$papers)[1]   >= 432)
})
