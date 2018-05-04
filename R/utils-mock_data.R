# read test data as html file from package install folder
read_test_html <- function(page) {
    test_load_loc  <- system.file("testdata", package = "petro.One")
    xml2::read_html(paste(test_load_loc, page, sep = "/"))
}

# write test data as html file to package local folder
write_test_html <- function(my_url, page) {
    test_save_loc  <- "./inst/testdata"
    xml2::write_html(xml2::read_html(my_url), file = paste(test_save_loc, page,
                                                           sep = "/"))
}

#' Generate data for offline testing
#' Mockup test data
#' @export
generate_offline_data <- function() {
    test_save_loc  <- "./inst/testdata"
    test_load_loc  <- system.file("testdata", package = "petro.One")
    test_save_file <- paste(test_save_loc, "optd.rda", sep = "/")
    test_load_file <- paste(test_load_loc, "optd.rda", sep = "/")

    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = TRUE)
    test.df.1 <- onepetro_page_to_dataframe(my_url)

    my_url <- make_search_url(query = "downhole flowrate measurement",
                              how = "all", from_year = 2001, to_year = 2007,
                              peer_reviewed = FALSE)
    test.df.2 <- onepetro_page_to_dataframe(my_url)


    gen_is_dctype_enabled(test_save_loc)
    gen_multipage(test_save_loc)

    # test_GTEsummary_by.R
    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    df <- papers_by_type(my_url)
    gtesb.df.01 <- papers_by_type(my_url)


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    gtesb.df.02 <- papers_by_publisher(my_url)


    my_url <- make_search_url(query = "mechanistic",
                              how = "all")
    gtesb.df.03 <- papers_by_publisher(my_url)


    my_url <- make_search_url(query = "IPR",
                              how = "all")
    gtesb.df.04 <- papers_by_publisher(my_url)


    my_url <- make_search_url(query = "BHP",
                              how = "all")
    gtesb.df.05 <- papers_by_publisher(my_url)


    my_url <- make_search_url(query = "shale gas",
                              how = "all")
    gtesb.df.06 <- papers_by_publisher(my_url)


    my_url <- make_search_url(query = "shale gas",
                              how = "all")
    gtesb.df.07 <- papers_by_year(my_url)


    my_url <- make_search_url(query = "production automation",
                              how = "all")
    gtesb.df.08 <- papers_by_year(my_url)


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    gtesb.df.09 <- papers_by_year(my_url)


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")
    gtesb.df.10 <- papers_by_year(my_url)


    my_url <- make_search_url(query = "mechanistic performance",
                              how = "all")
    gtesb.df.11 <- papers_by_year(my_url)

    my_url <- make_search_url(query = "mechanistic performance",
                              how = "any")
    gtesb.df.12 <- papers_by_year(my_url)

    my_url <- make_search_url(query = "mechanistic performance", how = "all")
    gtesb.df.13 <- papers_by_publication(my_url)

    my_url <- make_search_url(query = "mechanistic performance", how = "any")
    gtesb.df.14 <- papers_by_publication(my_url)


    # write to RDA
    test_save_file <- paste(test_save_loc, "optd.rda", sep = "/")
    save(test.df.1, test.df.2, file = test_save_file)

    test_save_file <- paste(test_save_loc, "gtesb.rda", sep = "/")
    save(gtesb.df.01, gtesb.df.02, gtesb.df.03, gtesb.df.04,
         gtesb.df.05, gtesb.df.06, gtesb.df.07, gtesb.df.08,
         gtesb.df.09, gtesb.df.10, gtesb.df.11, gtesb.df.12,
         gtesb.df.13, gtesb.df.14,
         file = test_save_file)
}


gen_html_file <- function(url, save_loc, html_file) {
    xml2::write_html(xml2::read_html(url), file = paste(save_loc, html_file, sep = "/"))
}


gen_is_dctype_enabled <- function(test_save_loc) {
    # is_dctype_enabled in summary.R
    # 1st test
    my_url <- make_search_url(query = "mechanistic performance", how = "all")
    gen_html_file(my_url, test_save_loc, "idcto_1.html")


    # 2nd test
    my_url <- make_search_url(query = "bottomhole nodal", how = "all")
    # xml2::write_html(xml2::read_html(my_url), file = paste(test_save_loc, "idcto_2.html", sep = "/"))
    gen_html_file(my_url, test_save_loc, "idcto_2.html")

    # 3rd test
    my_url <- make_search_url(query = "mechanistic", how = "all")
    # xml2::write_html(xml2::read_html(my_url), file = paste(test_save_loc, "idcto_3.html", sep = "/"))
    gen_html_file(my_url, test_save_loc, "idcto_3.html")

    # 4th test
    my_url <- make_search_url(query = "mechanistic performance", how = "any")
    # xml2::write_html(xml2::read_html(my_url), file = paste(test_save_loc, "idcto_4.html", sep = "/"))
    gen_html_file(my_url, test_save_loc, "idcto_4.html")
}



nn_from_to_year <- function(from, to) {
    my_url <- make_search_url(query = "neural network",
                              from_year = from,
                              to_year   = to,
                              how = "all")
    read_multidoc(my_url)        # rows=0
}



gen_multipage <- function(test_save_loc) {
    # my_url <- make_search_url(query = "neural network",
    #                           from_year = 1970,
    #                           to_year   = 1987,
    #                           how = "all")
    # df.7087 <- read_multidoc(my_url)        # rows=0

    df.7087 <- nn_from_to_year(1970, 1987)   # rows=0
    df.7088 <- nn_from_to_year(1970, 1988)   # rows=1
    df.7090 <- nn_from_to_year(1970, 1990)   # rows=17
    df.7095 <- nn_from_to_year(1970, 1995)   # rows=159
    df.7020 <- nn_from_to_year(1970, 2000)   # rows=517
    nn_by_year <- list(y7087 = df.7087, y7088 = df.7088, y7090 = df.7090, y7095 = df.7095, y7020 = df.7020)
    test_save_file <- paste(test_save_loc, "mpage_nn_by_year.rda", sep = "/")
    save(nn_by_year, file = test_save_file)
}

