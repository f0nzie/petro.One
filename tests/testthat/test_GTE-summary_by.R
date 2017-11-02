library(testthat)

context("new summaries: papers_by_type")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_type(my_url)
expect_gte(sum(df$value), 4)



context("new summaries: papers_by_publisher")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_gte(sum(df$value), 4)


my_url <- make_search_url(query = "mechanistic",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_gte(sum(df$value), 4938)


my_url <- make_search_url(query = "IPR",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_gte(sum(df$value), 1844)


my_url <- make_search_url(query = "BHP",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_gte(sum(df$value), 7890)


my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_gte(sum(df$value), 7598)



context("papers_by_year")

my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_year(my_url)
expect_gte(sum(df$value), 479899)


my_url <- make_search_url(query = "production automation",
                          how = "all")
df <- papers_by_year(my_url)
expect_gte(sum(df$value), 2275)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_year(my_url)
expect_gte(sum(df$value), 10)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_year(my_url)
expect_gte(sum(df$value), 150878)




context("papers_by_publication")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publication(my_url)
expect_gte(sum(df$value), 4)

my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_publication(my_url)
expect_gte(sum(df$value), 3276)
