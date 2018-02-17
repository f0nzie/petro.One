library(testthat)

context("expect_equal_scale")

test_that("expect_equal_scale is 10% tolerance", {
    expect_equal(petro.One:::expect_equal_scale(100, 100, tolerance_pct = 0.1), 100)
    expect_equal(petro.One:::expect_equal_scale(100, 95, tolerance_pct = 0.1), 100)
    expect_equal(petro.One:::expect_equal_scale(100, 90, tolerance_pct = 0.1), 100)
    expect_failure(petro.One:::expect_equal_scale(100, 89, tolerance_pct = 0.1))
    expect_failure(petro.One:::expect_equal_scale(100, 59, tolerance_pct = 0.1))
    expect_equal(petro.One:::expect_equal_scale(100, 99, tolerance_pct = 0.01), 100)
    expect_failure(petro.One:::expect_equal_scale(100, 98, tolerance_pct = 0.01))
})


context("unzip this")

test_that("zip file exists", {
    a_zip_file <- "3_pages_conference.zip"
    expect_true(file.exists(paste(system.file("extdata", package = "petro.One"),
                            a_zip_file, sep = "/")))

})


context("use_example")

test_that("no parameter is suplied", {
    expect_error(use_example())
    expect_error(use_example(2))
    expect_error(use_example(3))
})

test_that("use_example finds file, unzip and remove", {
    expect_silent(use_example(1))
    expect_silent(use_example(which_one = 1))
    the_files <- dir(getwd(), pattern = "_conference.html")
    file.remove(the_files)
})
