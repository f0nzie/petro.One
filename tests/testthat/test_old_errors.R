library(testthat)

context("Document types that were not uniform")

test_that("", {
    my_url <- make_search_url(query = "deepwater",
                              dc_type = "other")
    expect_equal(get_papers_count(my_url), 12)
    expect_equal(dim(onepetro_page_to_dataframe(my_url)), c(10, 5))
})


context("Problem: returns 0 rows when it had 69")
test_that("", {
    my_url <- make_search_url(query = "deepwater", dc_type = 'media')

    expect_equal(get_papers_count(my_url), 69)
    expect_equal(dim(onepetro_page_to_dataframe(my_url)), c(10, 5))
})


context("dc_type return different number of columns")
test_that("", {
    my_url <- make_search_url(query = "unconventional",
                          rows = 1000)

    expect_equal(get_papers_count(my_url), 17843)
    # 16359
    # 17843
    expect_equal(dim(onepetro_page_to_dataframe(my_url)), c(1000, 5))
    # Chapter	            1
    # Conference paper	14846
    # General	           42
    # Journal paper	     2701
    # Media	               71
    # Other	               26
    # Presentation	      155
    # Standard	            1
    by_type <- papers_by_type(my_url)
    expect_equal(by_type$value, c(1, 14846, 42, 2701, 71, 26, 155, 1))
    expect_equal(sum(by_type$value), 17843)
})
