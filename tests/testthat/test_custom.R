# Functions tested:
#   load_synonyms
#   change_to_synonym
#
library(testthat)

context("load_synonyms")

test_that("synonyms.txt file exists", {
    expect_true(file.exists(system.file("extdata", "synonyms.txt",
                                        package = "petro.One")))
})

test_that("synonyms.txt file is converted to dataframe", {
    synfile <- system.file("extdata", "synonyms.txt", package = "petro.One")
    custom_synonyms <- utils::read.table(file = synfile,
                                         header = TRUE, sep = "|",
                                         stringsAsFactors = FALSE)
    names(custom_synonyms) <- c("original", "replace_by")
    expect_s3_class(custom_synonyms, "data.frame")
    expect_equal(dim(custom_synonyms)[1], 32)
})

test_that("load_synonyms return a dataframe", {
    synonyms <- petro.One:::load_synonyms()
    expect_s3_class(synonyms, "data.frame")
    expect_equal(dim(synonyms)[1], 32)

})


context("change_to_synonym")

test_that("change_to_synonym makes the change to singular", {
    result <- petro.One:::change_to_synonym("algorithms")
    # print(result)
    expect_equal(result, "algorithm")
})


test_that("change_to_synonym makes the change to word with dash", {
    result <- petro.One:::change_to_synonym("big data")
    # print(result)
    expect_equal(result, "big-data")
})

test_that("change_to_synonym makes the change to common word with space prefix", {
    result <- petro.One:::change_to_synonym("fracturing")
    # print(result)
    expect_equal(result, " frack")
})


test_that("change_to_synonym makes the change to common word with no dash, space", {
    result <- petro.One:::change_to_synonym("multi phase")
    # print(result)
    expect_equal(result, "multiphase")
})


test_that("change_to_synonym makes the change to common word with no dash", {
    result <- petro.One:::change_to_synonym("multi-phase")
    # print(result)
    expect_equal(result, "multiphase")
})

test_that("change_to_synonym makes the change to common word with no dush, title case", {
    result <- petro.One:::change_to_synonym("Multi Phase")
    # print(result)
    expect_equal(result, "multiphase")
})
