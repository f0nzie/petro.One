library(testthat)

skip("skip")

context("test neural networks, rows=500 papers")
test_that("dim of papers is 500, 5", {
    url_nn <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 2000,
                              how = "all",
                              rows = 500)

    dims <- dim(get_papers_from_result_item(url_nn))  # 500, 5
    skip("skip")
    expect_equal(dims[1], 500)
    expect_equal(dims[2], 5)
})




context("test neural networks, no rows")
test_that("there are only 10 NN papers at this period", {
    # when no rows limit is supplied, it takes the default of rows=10
    url_nn <- make_search_url(query = "neural network",
                              from_year = 1970,
                              to_year   = 2000,
                              how = "all"
    )
    skip("skip")
    dims <- dim(get_papers_from_result_item(url_nn))  # 500, 5
    expect_equal(dims[1], 10)
    expect_equal(dims[2], 5)
})



context("test neural networks, rows=1000")
test_that("dataframe dimension is 1000x5", {
    url_nn <- make_search_url(query = "neural network",
                              how = "all",
                              rows = 1000
    )
    skip("skip")
    dims <- dim(get_papers_from_result_item(url_nn))  # 500, 5
    expect_equal(dims[1], 1000)
    expect_equal(dims[2], 5)
})


context("what happens when rows > 1000")
test_that("papers by type match for ALL", {
    url_nn <- make_search_url(query = "neural network",
                              how = "all"
                            )

    paper_count <- get_papers_count(url_nn)
    expect_equal(paper_count, 3238)
    by_type <- papers_by_type(url_nn)
    # name               value  OnePetro
    # <chr>              <dbl>
    # 1 Conference paper  2881  3149
    # 2 General              4     5
    # 3 Journal paper      323   351
    # 4 Media                2     2
    # 5 Other                5     5
    # 6 Presentation        23    23
    #   Standard            --     1
    expect_equal(by_type$value, c(2881, 4, 323, 2, 5, 23))
    expect_equal(nrow(get_papers_from_result_item(url_nn)), 10)
})

test_that("papers by type match for ANY", {
    url_nn <- make_search_url(query = "neural network",
                              how = "any"
    )
    paper_count <- get_papers_count(url_nn)
    expect_equal(paper_count, 3536)
    by_type <- papers_by_type(url_nn)
    # name               value  OnePetro
    # <chr>              <dbl>
    # 1 Conference paper  2881  3149
    # 2 General              4     5
    # 3 Journal paper      323   351
    # 4 Media                2     2
    # 5 Other                5     5
    # 6 Presentation        23    23
    #   Standard            --     1
    expect_equal(by_type$value, c(3149, 5, 351, 2, 5, 23, 1))
    expect_equal(nrow(get_papers_from_result_item(url_nn)), 10)
})
