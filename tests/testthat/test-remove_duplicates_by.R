library(testthat)

skip_on_travis()

major <- c("data driven")
minor <- c("drilling")

# the returning data structure is a a list
# the list contains two dataframes: one for the keywords and a second for the papers
dd_drilling <- join_keywords(major, minor, get_papers = TRUE, sleep = 3,
                             verbose = FALSE)
context("drilling and data driven papers by paper_id")
result <- remove_duplicates_by(dd_drilling$papers, by ="paper_id" )
expect_equal(dim(result), c(788, 7))

context("drilling and data driven papers by book_title")
result <- remove_duplicates_by(dd_drilling$papers, by ="book_title" )
expect_equal(dim(result), c(779, 7))
