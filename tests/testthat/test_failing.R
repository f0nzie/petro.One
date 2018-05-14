library(testthat)


context("fails at deepwater, other return GTE 12")

test_that("deepwater, other return GTE 12", {
    my_url <- make_search_url(query = "deepwater",
                              dc_type = "other")
    expect_true(get_papers_count(my_url) >= 12)
    # 12
    expect_true(dim(onepetro_page_to_dataframe(my_url))[1] >= 10)
})


context("Fails at deepwater, media return GTE 69")

test_that("deepwater, media return GTE 69", {
    my_url <- make_search_url(query = "deepwater", dc_type = 'media')

    expect_true(get_papers_count(my_url) >= 69)
    # 69
    expect_true(nrow(onepetro_page_to_dataframe(my_url)) >= 10)
})

skip("skip")
context("Fails at shale oil, all, conference-paper, with rows > 1000")

test_that("shale oil, all, conference-paper, works with rows > 1000", {
    my_url <- make_search_url(query = "shale oil",
                              how = "all",
                              dc_type = "conference-paper",
                              rows = 1100)
    # cat(get_papers_count(my_url))
    expect_true(get_papers_count(my_url) == 2772)
    # cat(papers_by_type(my_url)$value)
    expect_equal(papers_by_type(my_url)$value, c(2262, 20, 425, 8, 47, 13))
})
