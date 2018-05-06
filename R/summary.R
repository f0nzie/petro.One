library(rvest)


#' @title Summary by document type
#' @description Generate a summary by document type.
#' Types are: conference-paper, journal-paper, presentation, media, other, etc.
#' @param url a OnePetro page with results
#' @export
#' @examples
#' #
#' # Example 1
#' my_url <- make_search_url(query = "well test", how = "all")
#' papers_by_type(my_url)
#' @importFrom dplyr group_by summarize rename n
papers_by_type <- function(url) {
    if (get_papers_count(url) == 0) {   # return empty dataframe
        return(data.frame(type=as.character(), value = as.integer()))}

    url <- check_unlimited_rows(url)

    page <- xml2::read_html(url)

    if (is_dctype_enabled(page)) {
        # print(is_dctype_enabled(page))
        # paper types with paper counts
        x <- publication_result_right(page)
        len_list <- length(x)
        ix <- grep("All types", x)     # ix is the position in the vector
        # cat("ix:", ix, "\n")
        doctype_vector <- x[(ix+1):len_list]             # return a list with paper counts by type
        value <- extract_num_papers(doctype_vector)   # type of paper
        name  <- extract_publishers(doctype_vector)  # count by paper type
        tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
    } else {
        # No paper counts, no paper types because selector is disabled
        # find another of counting papers by type
        item_source <- get_item_source(page)
        item_source <- trimws(gsub("\n", "",item_source))
        df <- extract_source_when_disabled(item_source)
        type <- df$type
        df <- df %>%
            group_by(type) %>%
            summarize (value = n()) %>%
            rename(name = type)
        tibble::as.tibble(df)
    }
}


#' @title Summary by document type
#' @description Generate a summary by document type.
#' Types are: conference-paper, journal-paper, presentation, media, other, etc.
#' @param result a OnePetro page with results
#' @export
#' @examples
#' #
#' # Example 1
#' my_url <- make_search_url(query = "well test", how = "all")
#' result <- read_onepetro(my_url)
#' summary_by_doctype(result)
summary_by_doctype <- function(result) {
    x <- publication_result_right(result)
    doctype_vector <- get_dctype(x)
    value <- extract_num_papers(doctype_vector)
    name   <- extract_publishers(doctype_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}


extract_source_when_disabled <- function(item_source) {
    pattern   <- "^([^\\s]+\\s+)"
    paper_id  <- break_by_pattern(item_source, pattern)[[1]]
    right     <- break_by_pattern(item_source, pattern)[[2]]
    right     <- gsub("-", "", right)

    pattern <- "^([^\\s]+\\s+)"
    source  <- break_by_pattern(right, pattern)[[1]]
    right   <- break_by_pattern(right, pattern)[[2]]

    pattern <- "\\d+$"
    year    <- break_by_pattern(right, pattern)[[1]]
    type    <- break_by_pattern(right, pattern)[[2]]

    data.frame(paper_id, source, type, year, stringsAsFactors = FALSE)
}


break_by_pattern <- function(x, pattern) {
    m     <- regexpr(pattern, x, perl = TRUE)
    left  <- trimws(regmatches(x, m, invert = FALSE))
    right <- trimws(gsub(pattern, "", x, perl = TRUE))
    list(left, right)
}


#' @title Papers by publisher
#' @description Generate a summary by publisher.
#' Know publishers: OTC, SPE, etc.
#' @param url a OnePetro query URL
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "shale gas", how = "all")
#' papers_by_publisher(my_url)
papers_by_publisher <- function(url) {
    page <- xml2::read_html(url)
    x <- publication_result_right(page)
    pub_vector <- get_dc_publisher(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}


#' @title Summary by publisher
#' @description Generate a summary by publisher.
#' Know publishers: OTC, SPE, etc.
#' @param result a OnePetro page with results
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "shale gas", how = "all")
#' page <- read_onepetro(my_url)
#' summary_by_publisher(page)
summary_by_publisher <- function(result) {
    x <- publication_result_right(result)
    pub_vector <- get_dc_publisher(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}





#' @title Papers by Year
#' @description Generate a summary by the year the paper was published
#' @param url a OnePetro query URL
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "production automation", how = "all")
#' papers_by_year(my_url)
papers_by_year <- function(url) {
    page <- xml2::read_html(url)
    x <- publication_result_left(page)
    pub_vector <- get_dc_issued_year(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}



#' @title Summary by year
#' @description Generate a summary by the year the paper was published
#' @param result a OnePetro page with results
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "production automation", how = "all")
#' result <- read_onepetro(my_url)
#' summary_by_dates(result)
summary_by_dates <- function(result) {
    x <- publication_result_left(result)
    pub_vector <- get_dc_issued_year(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}


#' @title Papers by publication
#' @description Generate a summary by publications. These publications could
#' be World Petroleum Congress, Annual Technical
#' Meeting, SPE Unconventional Reservoirs Conference, etc.
#' @param url a OnePetro query URL
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "industrial drilling", how = "all")
#' papers_by_publication(my_url)
papers_by_publication <- function(url) {
    page <- xml2::read_html(url)
    x <- publication_result_left(page)
    pub_vector <- get_s2_parent_title(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}


#' @title Summary by publication
#' @description Generate a summary by publications. These publications could
#' be World Petroleum Congress, Annual Technical
#' Meeting, SPE Unconventional Reservoirs Conference, etc.
#' @param result a OnePetro page with results
#' @export
#' @examples
#' #
#' # Example
#' my_url <- make_search_url(query = "industrial drilling", how = "all")
#' result <- read_onepetro(my_url)
#' summary_by_publications(result)
summary_by_publications <- function(result) {
    x <- publication_result_left(result)
    pub_vector <- get_s2_parent_title(x)
    value <- extract_num_papers(pub_vector)
    name   <- extract_publishers(pub_vector)
    tibble::as.tibble(data.frame(name, value, stringsAsFactors = FALSE))
}


#' @importFrom magrittr %>%
publication_result_right <- function(result) {
    pub_doc <- result %>%
        html_nodes(".facet-unit-right") %>%
        html_nodes("option") %>%
        html_text()
    # print(pub_doc)
    pub_doc
}


#' @importFrom magrittr %>%
publication_result_left <- function(result) {
    pub_doc <- result %>%
        html_nodes(".facet-unit-left") %>%
        html_nodes("option") %>%
        html_text()
    pub_doc
}

. <- "Shut up"

# #' @title Is the document type selector enabled?
# #' @description Finds if the document type selector for dc_type is enabled or
# #' disabled. If it is disabled there will be no paper counts per document type
# #' in the web page
#' @importFrom rvest html_nodes html_attr
is_dctype_enabled <- function(page) {
    pub_doc <- page %>%
        html_nodes(".facet-unit-right") %>%
        html_nodes("select") %>%
        .[2] %>%
        html_attr("class")
    !grepl("disabled", pub_doc)
}


get_dctype <- function(aList) {
    len_list <- length(aList)
    ix <- grep("All types", aList)     # ix is the position in the vector
    # cat("ix:", ix, "\n")
    aList[(ix+1):len_list]
}

get_dc_publisher <- function(aList) {
    ix_stop <- grep("All types", aList)
    aList[2:(ix_stop-1)]
}

get_dc_issued_year <- function(aList) {
    ix_stop <- grep("All publications", aList)
    aList[2:(ix_stop-1)]
}

get_s2_parent_title <- function(aList) {
    len_list <- length(aList)
    ix <- grep("All publications", aList)
    aList[(ix+1):len_list]
}



extract_num_papers <- function(x) {
    pattern <- "(?<=\\{).+(?=\\})"
    m <- regexpr(pattern, x, perl = TRUE)
    as.numeric(gsub(",", "" , regmatches(x, m)))
}

extract_publishers <- function(x) {
    # pattern <- "(\\s[{\\d}].+)"
    pattern <- "\\s{([0-9].*)}"
    gsub(pattern, "", x, perl = TRUE)
}



