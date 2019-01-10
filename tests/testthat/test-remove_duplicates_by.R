library(testthat)

skip_on_travis()
skip_on_cran()

context("remove duplicates drilling and data driven papers")

major <- c("data driven")
minor <- c("drilling")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
dd_drilling <- join_keywords(major, minor, get_papers = TRUE, sleep = 3,
                             verbose = FALSE)
test_that("by paper_id", {
    result <- remove_duplicates_by(dd_drilling$papers, by ="paper_id" )
    expect_equal(dim(result), c(929, 7))
})


# context("drilling and data driven papers by book_title")
test_that("by book title", {
    result <- remove_duplicates_by(dd_drilling$papers, by ="book_title" )
    expect_equal(dim(result), c(920, 7))
})

