
do_not_read <- c("media", "standard", "other")

#' @title Read all OnePetro papers metadata by type of document
#' @description Function iterates through all found document types and extracts
#' papers into a common dataframe
#' @param my_url OnePetro query URL
#' @export
read_multidoc <- function(my_url) {

    sdc_df <- papers_by_type(my_url)

    # if no rows in dataframe are returned
    if (nrow(sdc_df) == 0) return(sdc_df)

    # looping through all types of documents found
    sdc_df$name <- tolower(sdc_df$name)   # to lowercase
    cum_df <- data.frame()                # accumulate dataframes

    for (doc in sdc_df$name) {
        if (!any(grepl(doc, do_not_read, ignore.case = TRUE))) {
            my_url <- set_doctype(my_url, doc)
            df <- read_multipage(my_url)       # read in groups of 1000 rows
            cum_df <- rbind(cum_df, df)
        }
    }
    cum_df
}


#' @title Reads metadata in groups of 1000 papers
#' @description This function will loop over and grab data from the OnePetro
#' results in groups of 1000 papers at a time.
#' OnePetro limits the number of papers to view to 1000 papers and the query in
#' this function automatically sets the start counter to read them in groups.
#' @param url A OnePetro query URL
#' @param doctype a OnePetro paper type: conference-paper, journal-paper, general.
#' presentation, chapter, etc.
#' @export
read_multipage <- function(url, doctype = NULL) {
    df_cum <- data.frame()
    doc <- urltools::param_get(url, "dc_type")
    if (is.null(doctype) && is.na (doc)) stop("must provide paper type")
    if (!is.null(doctype)) {
        # doc <- urltools::param_get(url, "dc_type")
        # print(doc)
        url <- urltools::param_set(url, "dc_type", doctype)
    }
    doc <- urltools::param_get(url, "dc_type")

    # TO-DO: make it universal for all type of papers
    # if paper type belong to a non structured data

    if (any(grepl(doc, do_not_read, ignore.case = TRUE))) {
        return(df_cum)
    } else {
        # read page by page in thousands size
        paper_count <- get_papers_count(url)

        # cat("paper_count:", paper_count, "\n")
        pages <- paper_count %/% 1000 + ifelse((paper_count %% 1000) > 0, 1, 0)

        for (page in 1:pages) {
            url <- urltools::param_set(url, "start", 1000 * page - 1000)
            url <- urltools::param_set(url, "rows", 1000)
            # cat(page, 1000 * page - 1000, get_papers_count(url), "\n")
            df <- onepetro_page_to_dataframe(url)
            # print(df[1, ])   # print first row of dataframe
            df_cum <- rbind(df_cum, df)  # accumulate dataframes
        }
    }
    df_cum
}





set_doctype <- function(url, doc) {
    if (doc == "chapter")          url <- urltools::param_set(url, "dc_type", "chapter")
    if (doc == "conference paper") url <- urltools::param_set(url, "dc_type", "conference-paper")
    if (doc == "journal paper")    url <- urltools::param_set(url, "dc_type", "journal-paper")
    if (doc == "presentation")     url <- urltools::param_set(url, "dc_type", "presentation")
    if (doc == "general")          url <- urltools::param_set(url, "dc_type", "general")
    url
}
