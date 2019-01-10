library(testthat)

skip_on_travis()
skip_on_cran()

context("papers by type, when specifying rows > 1000")

test_that("shale oil, all, conference-paper, works with rows > 1000", {
    my_url <- make_search_url(query = "unconventional oil",
                              how = "all",
                              dc_type = "conference-paper",
                              rows = 1100)

    # cat(get_papers_count(my_url))
    expect_equal(get_papers_count(my_url), 2144)
    expect_equal(papers_by_type(my_url)$value, c(1696, 3, 424, 5, 1, 15))

    p.by.pubshr <- papers_by_publisher(my_url)
    publisher <- "Society of Petroleum Engineers"
    expect_equal(p.by.pubshr[p.by.pubshr$name == publisher, ]$value, 1540)

    p.by.yr <- papers_by_year(my_url)
    year <- "Since 2010"
    expect_equal(p.by.yr[p.by.yr$name == year, ]$value, 2012)

    p.by.pubtn <- papers_by_publication(my_url)
    publication <- "Offshore Technology Conference"
    expect_equal(p.by.pubtn[p.by.pubtn$name == publication, ]$value, 24)
})
