library(testthat)

context("paper_count multitest function")
# test the following functions:
    # make_search_url
    # get_papers_count
    # read_onepetro

test_that("all queries match expected values", {

    expected <- c(71, 3238, 4868, 896, 8096, 13958, 13958, 570, 1800, 4, 9, 0, 4, 0)

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
    ix <- 1
    for (t in all_tests) {
        my_url <- make_search_url(query = t$keyword, how = t$how)
        # cat(t$how, my_url, "\n")
        cur_count <- get_papers_count(my_url)
        # cat(ix, cur_count, t$x, cur_count - t$x, "\n")
        expect_equal(cur_count, t$x)
        ix <- ix + 1
    }

})



