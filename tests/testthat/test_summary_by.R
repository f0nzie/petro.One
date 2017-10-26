library(testthat)

context("paper_by, summary_by")

my_url <- make_search_url(query = "well test",
                          how = "all")          # exact match
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
expect_equal(sum(df$value), 12068, tolerance = 10)


my_url <- make_search_url(query = "smart completion",
                          how = "all")          # exact match
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
expect_equal(sum(df$value), 397, tolerance = 10)



my_url <- make_search_url(query = "deepwater",
                          dc_type = "chapter")
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
expect_equal(sum(df$value), 3)


my_url <- make_search_url(query = "deepwater",
                          dc_type = "journal-paper")
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
petro.One:::expect_equal_scale(sum(df$value), 2430, tolerance_pct = 0.01)


my_url <- make_search_url(query = "deepwater",
                          dc_type = "general")
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
expect_equal(sum(df$value), 44)


my_url <- make_search_url(query = "pressure transient analysis",
                          how = "all")
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
# expect_equal(sum(df$value), 3996)
petro.One:::expect_equal_scale(sum(df$value), 3996, tolerance_pct = 0.03)



my_url_1 <- make_search_url(query = "pressure transient analysis",
                            how = "all",
                            dc_type = "conference-paper")
page <- read_onepetro(my_url)
df <- summary_by_doctype(page)
# expect_equal(sum(df$value), 3996)
petro.One:::expect_equal_scale(sum(df$value), 3996, tolerance_pct = 0.03)



context("new summaries: papers_by_type")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_type(my_url)
expect_equal(sum(df$value), 4)


context("new summaries: papers_by_publisher")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publisher(my_url)
expect_equal(sum(df$value), 4)


my_url <- make_search_url(query = "mechanistic",
                          how = "all")
df <- papers_by_publisher(my_url)
# expect_equal(sum(df$value), 4938)
petro.One:::expect_equal_scale(sum(df$value), 4938, tolerance_pct = 0.03)


my_url <- make_search_url(query = "IPR",
                          how = "all")
df <- papers_by_publisher(my_url)
# expect_equal(sum(df$value), 1807)
petro.One:::expect_equal_scale(sum(df$value), 1844, tolerance_pct = 0.02)


my_url <- make_search_url(query = "BHP",
                          how = "all")
df <- papers_by_publisher(my_url)
# expect_equal(sum(df$value), 7890)
petro.One:::expect_equal_scale(sum(df$value), 7890, tolerance_pct = 0.01)


my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_publisher(my_url)
# expect_equal(sum(df$value), 7504)
petro.One:::expect_equal_scale(sum(df$value), 7598, tolerance_pct = 0.02)



context("papers_by_year")

my_url <- make_search_url(query = "shale gas",
                          how = "all")
df <- papers_by_year(my_url)
# expect_equal(sum(df$value), 473413)
petro.One:::expect_equal_scale(sum(df$value), 479899, tolerance_pct = 0.02)


my_url <- make_search_url(query = "production automation",
                          how = "all")
df <- papers_by_year(my_url)
# expect_equal(sum(df$value), 2275)
petro.One:::expect_equal_scale(sum(df$value), 2275, tolerance_pct = 0.01)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_year(my_url)
expect_equal(sum(df$value), 10)
petro.One:::expect_equal_scale(sum(df$value), 10, tolerance_pct = 0.01)


my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_year(my_url)
# expect_equal(sum(df$value), 150878)
petro.One:::expect_equal_scale(sum(df$value), 150878, tolerance_pct = 0.01)




context("papers_by_publication")

my_url <- make_search_url(query = "mechanistic performance",
                          how = "all")
df <- papers_by_publication(my_url)
# expect_equal(sum(df$value), 4)
petro.One:::expect_equal_scale(sum(df$value), 4, tolerance_pct = 0.01)

my_url <- make_search_url(query = "mechanistic performance",
                          how = "any")
df <- papers_by_publication(my_url)
# expect_equal(sum(df$value), 3276)
petro.One:::expect_equal_scale(sum(df$value), 3276, tolerance_pct = 0.01)
