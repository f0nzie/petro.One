
#Loading the rvest package
library(rvest)

# Specifying the url for desired website to be scrapped
url <- "https://www.onepetro.org/search?start=0&q=neural+networks&from_year=&peer_reviewed=&published_between=&rows=999&to_year="

form_input <- list(dummy = "dummy", query = "?q=", peer_reviewed = "peer_reviewed=",
                   published_between = "published_between=",
                   from_year = "from_year=",
                   to_year = "to_year=",
                   start = "start=",
                   rows = "rows=",
                   dc_type = "dc_type=")

# Examples:
# https://www.onepetro.org/search?q=%22data+science%22&peer_reviewed=&published_between=&from_year=&to_year=
#




#' @title Read OnePetro web page given a query URL
#' @description Read a OnePetro webpage using a query URL. Uses xml2
#' function read_html
#' @param url char a query URL for OnePetro
#' @rdname read_onepetro
#' @importFrom xml2 read_html
#' @export
read_onepetro <- function(url) {
    #Reading the HTML code from the website
    read_html(url)
}


check_unlimited_rows <- function(url) {
    if (!is.na(urltools::param_get(url, "rows"))) {
        url <- urltools::param_remove(url, keys = c("start", "rows"))
    }
    url
}

#' @title Number of paper for a given query
#' @description Obtains the number of papers being queried by the URL
#' @param url char a query URL for OnePetro
#' @rdname get_papers_count
#' @importFrom magrittr %>%
#' @importFrom rvest html_nodes html_text
#' @export
#' @examples
#' # Example 1
#' url_1 <- make_search_url(query = "static gradient survey", how = "all")
#' get_papers_count(url_1)
#' #
#' # Example 2
#' url_2 <- make_search_url(query = "vertical lift performance", how = "all")
#' get_papers_count(url_2)
#' #
#' # Example 3
#' url_3 <- make_search_url(query = "inflow performance relationship", how = "all")
#' get_papers_count(url_3)
get_papers_count <- function(url) {
    # result <- send_url(url)

    url <- check_unlimited_rows(url)
    result <- xml2::read_html(url)

    papers <- result %>%
    html_nodes("h2") %>%
    html_text()

    # extract the numeric part of the results
    pattern <- "[\\d,]+(?= results.)"    # a number, including comma, before " results."
    m <- regexpr(pattern, papers[1], perl = TRUE)       # matched
    as.numeric(gsub(",", "", regmatches(papers[1], m))) # remove comma first
}


#' @title Make a search URL for OnePetro
#' @description Create a URL that works in OnePetro website
#' @param query char         any words that will be searched
#' @param start int          optional to set the starting paper
#' @param from_year int      optional to indicate starting year
#' @param peer_reviewed     logical optional, TRUE or FALSE
#' @param published_between logical automatic if from_year or to_year are on
#' @param rows int           optional. number of papers to retrieve. max=1000
#' @param to_year int        optional to indicate end year
#' @param dc_type char       optional to indicate if journal, conference paper
#' @param how char           default="any". "all" will match exact words
#' @export
#' @examples
#' # Example 1
#' url_1 <- make_search_url(query = "flowing gradient survey", how = "all")
#' onepetro_page_to_dataframe(url_1)
#' # Example 2
#' url_2 <- make_search_url(query = "static  gradient survey", how = "all")
#' onepetro_page_to_dataframe(url_2)
#' # Example 3
#' url_3 <- make_search_url(query = "downhole flowrate measurement",
#'       how = "all", from_year = 1982, to_year = 2017)
#' onepetro_page_to_dataframe(url_3)
make_search_url <- function(query = NULL, start = NULL, from_year = NULL,
                            peer_reviewed = NULL,
                            published_between = NULL,
                            rows = NULL,
                            to_year = NULL,
                            dc_type = NULL,
                            how = "any") {

    website <- "https://www.onepetro.org"

    if (!is.null(start) || !is.null(rows)) {
        if (!is.null(rows) & is.null(start)) start = 0
        stopifnot(is.numeric(start), is.numeric(rows))
    }

    if (!is.null(from_year) && !is.null(to_year)) {
        stopifnot(is.numeric(from_year), is.numeric(to_year))
    }

    if (is.null(query)) {
        stop("search words not provided")
    } else {
        split_query <- unlist(strsplit(query, " "))
        if (length(split_query) > 1) {
            query <- paste(split_query, collapse = "+")
            query <- ifelse(how == "all", paste0("'", query, "'"), query)
            # print(query)
        }
    }

    if (!is.null(from_year) || !is.null(to_year)) {
        # use regex to validate year is between 1900 and 2099
        pattern <- "(?:(?:19|20)[0-9]{2})"
        if (!grepl(pattern, from_year, perl = TRUE) ||
            !grepl(pattern, to_year,   perl = TRUE)) stop("year not valid")
        # if valid year then turn on published_between
        published_between = "on"
        # if any of the *from* or *to* years are null replace with empty char
        if (is.null(from_year)) {
            from_year = ""
        }
        if (is.null(to_year)) {
            to_year = ""
        }
    }

    # peer_reviewed=on if TRUE; blank if unslected or FALSE
    if (is.null(peer_reviewed)) {
        peer_reviewed = ""
    } else {
        if (peer_reviewed) peer_reviewed = "on"
    }

    # document type
    if (!is.null(dc_type)) {
        valid_options <- c("conference-paper", "journal-paper",
                           "media", "general", "presentation", "chapter",
                           "other", "standard")
        # stop if it is not in the options
        if (!dc_type %in% valid_options) {
            msg <- sprintf("Option unknown. It must be one of [ %s ]",
                           paste(valid_options, collapse = ", "))
            stop(msg)
            # cat(valid_options, "\n")
        }
    }

    s_search  <- paste(website, "search", sep = "/")

    # these strings will need to join with the ampersand & at the tail
    s_query   <- paste0("?q=", query)
    s_peer    <- paste0("peer_reviewed=", peer_reviewed)
    s_publish <- paste0("published_between=", published_between)
    s_from    <- paste0("from_year=", from_year)
    s_to      <- paste0("to_year=", to_year)
    s_start   <- paste0("start=", start)
    s_rows    <- paste0("rows=", rows)
    s_type    <- paste0("dc_type=", dc_type)

    # url
    s_url <- list(websearch = s_search, query = s_query, peer = s_peer,
                  published_between = s_publish, from_year = s_from, to_year = s_to,
                  start = s_start, rows = s_rows, dc_type = s_type
    )

    for (i in 1:length(s_url)) {
        # cat(i, my_url[[i]], "\n")
        if (i == 1) joined <- s_url[[i]]
        if (i == 2) joined <- paste0(joined, s_url[[i]])
        if (i >=3 ) {
            if (s_url[[i]] == form_input[[i]] & i <= 6) {
                joined <- paste(joined, s_url[[i]], sep = "&")
            } else  if (s_url[[i]] != form_input[[i]]) {
                # cat(i, s_url[[i]], "\n")
                joined <- paste(joined, s_url[[i]], sep = "&")
            }
        }
    }

    q_url <- joined
    q_url <- gsub('"', "'", q_url)
    q_url <- gsub("'", '"', q_url)
    q_url
}








create_url <- function(start = NULL, query = NULL, from_year = NULL,
                       peer_reviewed = NULL,
                       published_between = NULL,
                       rows = NULL,
                       to_year = NULL,
                       how = "any") {

    website <- "https://www.onepetro.org"

    if (is.null(start)) {
        start = ""
    }
    if (is.null(query)) {
        stop("search words not provided")
    } else {
        split_query <- unlist(strsplit(query, " "))
        if (length(split_query) > 1) {
            query <- paste(split_query, collapse = "+")
            # use function shQuote to add extra quotes when we want how = "all"
            query <- ifelse(how == "all", shQuote(query), query)
            print(query)
        }
    }
    print(query)

    if (is.null(from_year)) {
        from_year = ""
    }
    if (is.null(peer_reviewed)) {
        peer_reviewed = ""
    }
    if (is.null(published_between)) {
        published_between = ""
    }
    if (is.null(rows)) {
        rows = ""
    } else {
        if(is.null(start)) start = 0
    }
    if (is.null(to_year)) {
        to_year = ""
    }

    s_search  <- paste(website, "search", sep = "/")
    s_q       <- paste0("?q=", query)
    s_peer    <- paste0("peer_reviewed=", peer_reviewed)
    s_publish <- paste0("published_between=", published_between)
    s_from    <- paste0("from_year=", from_year)
    s_to      <- paste0("to_year=", to_year)
    s_start   <- paste0("start=", start)
    s_rows    <- paste0("rows=", rows)

    url <- paste(s_q, s_peer, s_publish, s_from, s_to, sep = "&")
    url <- paste0(s_search, url)
    url
}


send_url <- function(url, how = "any") {
    #Reading the HTML code from the website
    read_html(url)
}
