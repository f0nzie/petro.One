library(testthat)

context("paper_count multitest function")

# test the following functions:
    # make_search_url
    # get_papers_count
    # read_onepetro

test_that("all queries match expected values", {

    expected <- c(70, 2998, 4676, 871, 7876, 13577, 13577, 533, 1750, 4, 9, 0, 4, 0)

    all_tests <- list(
        test_1 = list(
            x = expected[1],
            keyword = "smartwell",
            how = "all",
            tolerance = 0.01,
            scale = expected[1]
        ),

        test_2 = list(
            x = expected[2],
            keyword = "neural network",
            how = "all",
            tolerance = 0.05,
            scale = expected[2]
        ),

        test_3 = list(
            x = expected[3],
            keyword = "intelligent completion",
            how = "any",
            tolerance = 0.01,
            scale = expected[3]
        ),

        test_4 = list(
            x = expected[4],
            keyword = "intelligent completion",
            how = "all",
            tolerance = 0.01,
            scale = expected[4]
        ),

        test_5 = list(
            x = expected[5],
            keyword = "heat transfer",
            how = "all",
            tolerance = 0.01,
            scale = expected[5]
        ),

        test_6 = list(
            x = expected[6],
            keyword = "heat transfer",
            how = "any",
            tolerance = 0.01,
            scale = expected[6]
        ),

        test_7 = list(
            x = expected[7],
            keyword = "heat transfer",
            how = "",
            tolerance = 0.01,
            scale = expected[7]
        ),

        test_8 = list(
            x = expected[8],
            keyword = "digital oilfield",
            how = "all",
            tolerance = 0.05,
            scale = expected[8]
        ),

        test_9 = list(
            x = expected[9],
            keyword = "mechanistic model",
            how = "all",
            tolerance = 0.01,
            scale = expected[9]
        ),

        test_10 = list(
            x = expected[10],
            keyword = "mechanistic physics",
            how = "all",
            tolerance = 0.01,
            scale = expected[10]
        ),

        test_11 = list(
            x = expected[11],
            keyword = "mechanistic correlation",
            how = "all",
            tolerance = 0.01,
            scale = expected[11]
        ),

        test_12 = list(
            x = expected[12],
            keyword = "mechanistic vertical lift",
            how = "all",
            tolerance = 0.01,
            scale = expected[12]
        ),

        test_13 = list(
            x = expected[13],
            keyword = "mechanistic performance",
            how = "all",
            tolerance = 0.01,
            scale = expected[13]
        ),

        test_14 = list(
            x = expected[14],
            keyword = "mechanistic tubing",
            how = "all",
            tolerance = 0.01,
            scale = expected[14]
        )

    )

    for (t in all_tests) {
        # print(t)
        my_url <- make_search_url(query = t$keyword, how = t$how)
        # cat(t$how, my_url, "\n")
        # print(get_papers_count(my_url))
        expect_equal(get_papers_count(my_url), t$x, t$tolerance, t$scale)
    }

})



# test_that("get_papers_count matches smartwell papers", {
#     my_url <- make_search_url(query = "smartwell")
#     expect_equal(get_papers_count(my_url), 70)
#
# })
#
#
# test_that("get_papers_count matches ALL *neural network* papers", {
#     my_url <- make_search_url(query = "neural network", how = "all")
#     print(my_url)
#     xml2::read_html(my_url)
#     # expect_equal(get_papers_count(my_url), 2998)
#     # expect_equal(get_papers_count(my_url), 3025, tolerance = 50)
# })
#
#
# test_that("get_papers_count matches *intelligent completion* papers", {
#     expected <- 4527
#     my_url <- make_search_url(query = "intelligent completion", how = "any")
#     # my_url <- gsub('"', "'", my_url)
#     # my_url <- gsub("'", '"', my_url)
#     print(my_url)
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected, tolerance = expected*0.1)
# })
#
#
# test_that("get_papers_count matches ALL *intelligent completion* papers", {
#     expected <- 845
#     tol <- 0.01
#     my_url <- make_search_url(query = "intelligent completion", how = "all")
#     # my_url <- gsub('"', "'", my_url)
#     # my_url <- gsub("'", '"', my_url)
#     print(my_url)
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected, tolerance = tol, scale = expected)
#     # 845
# })
#
#
# test_that("get_papers_count matches ALL *heat transfer* papers", {
#     expected <- 7876
#     my_url <- make_search_url(query = "heat transfer", how = "all")
#     expect_equal(get_papers_count(my_url), expected)
# })
#
# test_that("get_papers_count matches ANY *heat transfer* papers", {
#     expected <- 13577
#     my_url <- make_search_url(query = "heat transfer", how = "any")
#     expect_equal(get_papers_count(my_url), expected)
# })
#
# test_that("get_papers_count matches *heat transfer* papers", {
#     # default how=any
#     expected <- 13577
#     my_url <- make_search_url(query = "heat transfer")
#     expect_equal(get_papers_count(my_url), expected)
# })
#
#
# test_that("get_papers_count matches ALL *digital oilfield* papers", {
#     expected <- 533
#     tol <- 0.01
#     my_url <- make_search_url(query = "digital oilfield", how = "all")
#     expect_equal(get_papers_count(my_url), expected, tolerance = tol, scale = expected)
#     # print(get_papers_count(my_url))
# })
#
# test_that("get_papers_count matches ALL *mechanistic model* papers", {
#     expected <- 1750
#     tol <- 0.01
#     my_url <- make_search_url(query = "mechanistic model", how = "all")
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected, tolerance = tol, scale=expected)
#     # print(get_papers_count(my_url))
# })
#
#
# test_that("get_papers_count matches ALL *mechanistic physics* papers", {
#     expected <- 4
#     tol <- 0.01
#     my_url <- make_search_url(query = "mechanistic physics", how = "all")
#     print(my_url)
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected, tolerance = tol, scale = expected)
#     # print(get_papers_count(my_url))
# })


# test_that("get_papers_count matches ALL *mechanistic correlation* papers", {
#     expected <- 8
#     my_url <- make_search_url(query = "mechanistic correlation", how = "all")
#     print(my_url)
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected)
#     # print(get_papers_count(my_url))
# })

# test_that("get_papers_count matches ALL *mechanistic vertical lift* papers", {
#     expected <- 534
#     my_url <- make_search_url(query = "mechanistic vertical lift", how = "all")
#     print(my_url)
#     print(get_papers_count(my_url))
#     expect_equal(get_papers_count(my_url), expected)
# })


# test_that("get_papers_count matches ALL *mechanistic * papers", {
#     x <- 3299
#     tol <- 0.01
#     delta <- tol*x
#     my_url <- make_search_url(query = "mechanistic performance", how = "all")
#     print(my_url)
#     print(get_papers_count(my_url))
#     print(delta)
#     expect_equal(get_papers_count(my_url), x, tolerance = tol, scale = x)
# })
