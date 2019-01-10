library(testthat)

skip_on_cran()
skip_on_travis()

context("new summaries: papers_by_type")

test_that("mechanistic performance match papers_by_type()", {
    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    df <- papers_by_type(my_url)
    expect_equal(sum(df$value), 4)
})




context("new summaries: papers_by_publisher")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 4)


my_url <- make_search_url(query = "mechanistic",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 5410)


my_url <- make_search_url(query = "IPR",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 1979)


my_url <- make_search_url(query = "BHP",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 8485)


my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 8600)



context("papers_by_year")

my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_year(my_url)
expect_equal(sum(df$value), 549915)


my_url <- make_search_url(query = "production automation",
                          how = "all")
df <- papers_by_year(my_url)
expect_equal(sum(df$value), 2437)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_year(my_url)
expect_equal(sum(df$value), 10)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_year(my_url)
expect_equal(sum(df$value), 170983)




context("papers_by_publication")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publication(my_url)
expect_equal(sum(df$value), 4)

my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_publication(my_url)
expect_equal(sum(df$value), 3623)
