
#' Run a papers search providing multiple keywords
#'
#' This search performs search of papers by provifing multiple levels of keywords.
#' The levels can have one or more keywords and the levels can be as many as desired.
#' Deeper levels makes the search longer.
#'
#' @param ... keywords and keyword levels
#' @param get_papers TRUE to retrieve the papers. FALSE, only return the count
#' @param sleep delay in seconds between search to OnePetro
#' @param verbose TRUE if we want internal messages of the search progress
#' @param len_keywords length of the keywords to form the filename of the rda file
#' @param allow_duplicates if TRUE, it will allow duplicates based on book_title and
#' paper_id
#' @param save_to_rda logical that indicates if we want to save results to an RDA
#'
#' @importFrom dplyr distinct %>%
#' @export
run_papers_search <- function(...,
                              get_papers = TRUE,
                              sleep = 3,
                              verbose = TRUE,
                              len_keywords = 3,
                              allow_duplicates = TRUE,
                              save_to_rda = FALSE) {

    paper_id <- NULL; book_title <- NULL; rda_filename <- ""

    # join the keywords to searh in OnePetro
    papers_obj <- join_keywords(..., get_papers = get_papers,
                                sleep = sleep, verbose = verbose)
    keywords <- papers_obj$keywords
    papers   <- papers_obj$papers

    # eliminate duplicates
    if (!allow_duplicates) {
        if (nrow(papers) > 1) {
            papers <- papers %>%
                distinct(paper_id, book_title, .keep_all = TRUE)
        }
    }

    # create an object to group all search objects, including paper results
    search_keywords <- list(...)

    # create filename from the keywords
    if (save_to_rda) {
        comb_keyw <- c(search_keywords[1], search_keywords[2])  # combine keywords
        rda_filename <- paste0(lapply(list(unlist(comb_keyw)),
                                      function(x) paste(substr(x, 1, len_keywords),
                                                        collapse = "_")), ".rda")
    } else {
        rda_filename <- NULL
    }
    print(rda_filename)

    # collect all objects in a list
    paper_search_obj <- as_named_list(papers,
                                      keywords,
                                      search_keywords,
                                      rda_filename)

    # save the object to RDA file
    # why do we save the RDA file? To avoid doing the previous online request
    if (save_to_rda) save(paper_search_obj, file = rda_filename)
    return(paper_search_obj)
}



#' Get paper count and paper dataframe by joining keywords as vectors
#' @param ...     input character vectors
#' @param bool_op boolean operator. It can be AND or OR
#' @param get_papers generate or not a dataframe with papers
#' @param sleep seconds to wait before a new quiery to OnePetro
#' @param verbose show progress if TRUE
#' @import data.table
#' @export
join_keywords <- function(...,
                          get_papers = TRUE,
                          bool_op = "AND",
                          sleep = 3,
                          verbose = FALSE) {
    rec <- vector("list")
    papers.df.k <- data.frame()

    # works for "n" columns or "n" keyword character vectors
    df <- expand.grid(..., stringsAsFactors = FALSE)   # combine keywords
    sep     <- paste0("'", bool_op, "'")               # add apostrophes to operator
    # iterate through the rows of keyword combinations dataframe
    for (i in 1:nrow(df)) {
        sf <- NULL
        papers.df <- NULL
        # iterate through columns of keywords
        for (j in 1:ncol(df)) {
            s     <- unlist(strsplit(df[i, j], " "))   # split keyword if space
            splus <- paste(s, collapse = "+")          # join keywords with + sign
            if (!is.null(sf)) {
                sf <- paste(sf, splus, sep = sep)      # if not the 1st keyword add AND
            } else {                                   # else
                sf <- paste0("'", sf, splus)           # just join 1st with next kword
            }
        }
        sf <- paste0(sf, "'")                          # close with apostrophe
        url.1 <- make_search_url(sf, how = "all")      # search in OnePetro
        paper_count <- get_papers_count(url.1)         # paper count

        if (verbose) cat(sprintf("%3d %5d %-60s \n", i, paper_count, sf))

        # build a record of results
        rec[[i]] <- list(paper_count = paper_count, sf  = sf, url = url.1)

        # create a dataframe of papers based on the paper count
        if ((get_papers) && (paper_count > 0)) {  # do this only if we have papers
            # url.2 <- make_search_url(sf, how = "all", rows = paper_count)
            url.2 <- make_search_url(sf, how = "all")
            # papers.df <- onepetro_page_to_dataframe(url.2)    # get papers
            # # get multipages > 1000 papers
            # papers.df <- read_multipage(url.2, doctype = "conference-paper")
            papers.df <- read_multipage(url.2, verbose = verbose)
            # cat(dim(papers.df), "\n")
            papers.df$keyword <- sf                           # add columns
            papers.df.k <- rbind(papers.df, papers.df.k)      # cumulative dataframe
        }
        Sys.sleep(sleep)                    # give OnePetro a break
    }
    rec.df <- data.table::rbindlist(rec)    # convert list to dataframe
    df <- tibble::as.tibble(cbind(df, rec.df))            # join the results
    invisible(list(keywords=df, papers=papers.df.k))      # return cumulative dataframe
}
