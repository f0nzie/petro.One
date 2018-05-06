# offline unit test. using real data in HTML files
library(testthat)

test_load_loc  <- system.file("testdata", package = "petro.One")
test_load_file <- paste(test_load_loc, "gtesb.rda", sep = "/")
load(test_load_file)


context("new summaries: papers_by_type")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")

m <- mock(gtesb.df.01)
with_mock(papers_by_type = m, {
    df <- papers_by_type(my_url)
    expect_gte(sum(df$value), 4)
})



context("new summaries: papers_by_publisher")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
m <- mock(gtesb.df.02)
with_mock(papers_by_publisher = m, {
    df <- papers_by_publisher(my_url)
    expect_gte(sum(df$value), 4)
})

my_url <- make_search_url(query = "mechanistic",
                          how = "all")
m <- mock(gtesb.df.03)
with_mock(papers_by_publisher = m, {
    df <- papers_by_publisher(my_url)
    expect_gte(sum(df$value), 4938)
})

my_url <- make_search_url(query = "IPR",
                          how = "all")
m <- mock(gtesb.df.04)
with_mock(papers_by_publisher = m, {
    df <- papers_by_publisher(my_url)
    expect_gte(sum(df$value), 1844)
})

my_url <- make_search_url(query = "BHP",
                          how = "all")
m <- mock(gtesb.df.05)
with_mock(papers_by_publisher = m, {
    df <- papers_by_publisher(my_url)
    expect_gte(sum(df$value), 7890)
})

my_url <- make_search_url(query = "shale gas",
                          how = "all")
m <- mock(gtesb.df.06)
with_mock(papers_by_publisher = m, {
    df <- papers_by_publisher(my_url)
    expect_gte(sum(df$value), 7598)
})



context("papers_by_year")

my_url <- make_search_url(query = "shale gas", how = "all")
m <- mock(gtesb.df.07)
with_mock(papers_by_year = m, {
    df <- papers_by_year(my_url)
    expect_gte(sum(df$value), 479899)
})

my_url <- make_search_url(query = "production automation", how = "all")
m <- mock(gtesb.df.08)
with_mock(papers_by_year = m, {
    df <- papers_by_year(my_url)
    expect_gte(sum(df$value), 2275)
})


my_url <- make_search_url(query = "mechanistic performance", how = "all")
m <- mock(gtesb.df.09)
with_mock(papers_by_year = m, {
    df <- papers_by_year(my_url)
    expect_gte(sum(df$value), 10)
})

my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
m <- mock(gtesb.df.10)
with_mock(papers_by_year = m, {
    df <- papers_by_year(my_url)
    expect_gte(sum(df$value), 150878)
})



context("papers_by_publication")

my_url <- make_search_url(query = "mechanistic performance", how = "all")
m <- mock(gtesb.df.11)
with_mock(papers_by_publication = m, {
    df <- papers_by_publication(my_url)
    expect_gte(sum(df$value), 4)
})

my_url <- make_search_url(query = "mechanistic performance", how = "any")
m <- mock(gtesb.df.12)
with_mock(papers_by_publication = m, {
    df <- papers_by_publication(my_url)
    expect_gte(sum(df$value), 3276)
})

