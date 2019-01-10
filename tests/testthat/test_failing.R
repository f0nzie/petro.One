# functions tested
#   onepetro_page_to_dataframe()
#   papers_by_type()
#   get_papers_count()
#   make_search_url()

library(testthat)

skip_on_cran()
skip_on_travis()

context("this fails at deepwater")

test_that("deepwater, other return GTE 12", {
    my_url <- make_search_url(query = "deepwater",
                              dc_type = "other")
    expect_equal(get_papers_count(my_url), 12)
    # 12
    expect_equal(dim(onepetro_page_to_dataframe(my_url))[1], 10)
})


context("Fails at deepwater and media type")

test_that("deepwater, media type", {
    my_url <- make_search_url(query = "deepwater", dc_type = 'media')

    expect_equal(get_papers_count(my_url), 73)
    # 69
    expect_equal(nrow(onepetro_page_to_dataframe(my_url)), 10)
})



context("Fails at shale oil, all, conference-paper, with rows > 1000")

test_that("shale oil, all, conference-paper, works with rows > 1000", {
    my_url <- make_search_url(query = "shale oil",
                              how = "all",
                              dc_type = "conference-paper",
                              rows = 1100)
    # cat("\t", get_papers_count(my_url), "\n")
    expect_equal(get_papers_count(my_url), 3048)
    # cat("\t", papers_by_type(my_url)$value, "\n")
    expect_equal(papers_by_type(my_url)$value, c(2482, 21, 461, 9, 47, 28))
})
