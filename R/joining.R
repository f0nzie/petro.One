
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
                          verbose = TRUE) {
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
        if (get_papers) {
            url.2 <- make_search_url(sf, how = "all", rows = paper_count)
            papers.df <- onepetro_page_to_dataframe(url.2)    # get papers
            papers.df$keyword <- sf                           # add columns
            papers.df.k <- rbind(papers.df, papers.df.k)      # cumulative dataframe
        }
        Sys.sleep(sleep)                    # give OnePetro a break
    }
    rec.df <- data.table::rbindlist(rec)    # convert list to dataframe
    df <- cbind(df, rec.df)                 # join the results
    invisible(list(keywords=df, papers=papers.df.k))      # return cumulative dataframe
}
