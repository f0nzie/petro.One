
#' @title Reads a OnePetro URL and converts it to a dataframe
#' @description A OnePetro URL with a query is read into a HTML page and
#' converted to a dataframe
#' @param url char a OnePetro type URL
#' @export
#' @examples
#' # Example 1
#' # Search papers with keyword "smartwell"
#' url_sw <- "https://www.onepetro.org/search?q=smartwell"
#' onepetro_page_to_dataframe(url_sw)
#' # Example 2
#' # Search for exact words ""vertical lift performance"
#' url_vlp <- "https://www.onepetro.org/search?q=%22vertical+lift+performance%22"
#' onepetro_page_to_dataframe(url_vlp)
onepetro_page_to_dataframe <- function(url) {
    webpage    <- read_html(url)
    df_titles  <- read_titles(webpage, url)
    df_sources <- read_sources(webpage, url)
    df_author  <- read_author(webpage, url)

    # ensure that all dataframes have the same number of rows
    if (all(dim(df_titles)[1]  == dim(df_sources)[1],
            dim(df_sources)[1] == dim(df_author)[1],
            dim(df_author)[1]  == dim(df_titles)[1]
    ))
        df <- cbind(df_titles, df_sources, df_author)
    else
        stop("Dataframe sizes different")  # otherwise, stop

    return(tibble::as.tibble(df))
}



onepetro_allpages_to_dataframe <- function(url) {
    # webpage <- read_html(url)
    papers_count <- get_papers_count(url)
    if (papers_count > 1000) {
        num_pages <- papers_count / 1000
    } else {
        num_pages = 1
    }

    info <- list(papers = papers_count, pages1000 = num_pages)

    for (page in seq_len(num_pages)) {
        # webpage <- read_html(url)

    }
    info
}


#' @importFrom rvest html_nodes html_text
read_titles <- function(webpage, url) {
    # define empty dataframe
    title_data <- data.frame(title_data = character())

    # dc_type will bring us to right function to parse
    dc_type <- urltools::param_get(url, "dc_type")

    if (is.na(dc_type)) {
        title_data_txt <- get_result_link(webpage)
    } else {
        if (dc_type == "media" | dc_type == "other") {
            title_data_txt <- get_result_item_title(webpage, url)
        } else {
            title_data_txt <- get_result_link(webpage)
        }
    }
    if (length(title_data_txt) != 0 ) {
        # data pre-processing
        title_data_txt <- data.frame(title_data = as.character(title_data_txt),
                                 stringsAsFactors = FALSE)
    }
    return(title_data_txt)
}




get_result_link <- function(webpage) {
    # applicable to dc-type in c("conference-paper", "journal-paper", "presentation",
    #                            "standard", "chapter", "general")
    # Using CSS selectors to scrap the rankings section
    title_data_html <- rvest::html_nodes(webpage, '.result-link')
    # Converting the ranking data to text
    title_data_txt <- rvest::html_text(title_data_html)
    # remove blanks
    title <- trimws(gsub("\n", "", title_data_txt))
    return(title)
}


get_result_item <- function(webpage, url) {
    # applicable to dc-type in c("media", "other")
    title_data_html <- rvest::html_nodes(webpage, '.result-item')
    title_data_txt <- rvest:::html_text(title_data_html)
    # remove whitespaces
    L <- lapply(strsplit(as.character(title_data_txt), '\n', fixed=TRUE), trimws)
    # remove (rm) blank (b) elements from list
    Lrmb <- lapply(L, function(x) x[!x %in% ""])
    # remove "Conference:" (c) because it has empty row
    Lrmb <- lapply(Lrmb, function(x) x[!x %in% "Conference:"])

    # remove "Visit External Site" and "," when dc-type="other"
    Lrmb <- lapply(Lrmb, function(x) x[!x %in% "Visit External Site"])
    Lrmb <- lapply(Lrmb, function(x) x[!x %in% ","])
    # remove last member of list (ll) because it is empty
    Lrmbll <- petro.One:::remove_last_of_list(Lrmb)
    return(Lrmbll)
}


get_result_item_title <- function(webpage, url) {

    Lrmbll <- get_result_item(webpage, url)

    dc_type <- urltools::param_get(url, "dc_type")

    if (dc_type == "media") {
        # pick the third element of list because contains the title
        title <- lapply(Lrmbll, function(x) x[3])
        title <- gsub(pattern = "Article: ", "", title)
    } else {
        # dc-type="other": pick the first element of the list
        title <- lapply(Lrmbll, function(x) x[1])
    }
    return(title)
}



#' @importFrom rvest html_nodes html_text
get_item_source <- function(webpage) {
    # Using CSS selectors to scrap the rankings section
    source_data_html <- html_nodes(webpage, '.result-item-source')

    # Converting the ranking data to text
    source_data_txt <- html_text(source_data_html)

    # remove line breaks
    source_data_txt <- strsplit(as.character(source_data_txt), '\n', fixed = TRUE)
    return(source_data_txt)
}


get_result_item_source <- function(webpage, url) {
    dc_type <- urltools::param_get(url, "dc_type")
    result_item <- get_result_item(webpage, url)

    if (dc_type == "media") {
        if (length(which(sapply(result_item, length) < 6)) > 0) {
            # find rows that have less than six elements
            index_rows <- which(sapply(result_item, length) < 6)
            # make the new 6th element equal to blank
            lapply(index_rows, function(x) result_item[[x]][6] <<- "")
        }
    } else {   # dc-type="other"
        if (length(which(sapply(result_item, length) < 2)) > 0) {
            # when the list only has one member. it should have title and authors
            index_rows <- which(sapply(result_item, length) < 2)
            item_source <- lapply(index_rows, function(x) result_item[[x]][2] <<- "")
        }
        if (length(which(sapply(result_item, length) > 2)) > 0) {
            # when the list has many authors put them in the 2nd member
            index_rows <- which(sapply(result_item, length) > 2)
            # take only the 1st and 2nd elements. ignore other authors
            lapply(index_rows, function(x)
                result_item[[x]] <<- result_item[[x]][c(1, 2)])
        }
    }
    return(result_item)
}



#' @importFrom rvest html_nodes html_text
read_sources <- function(webpage, url) {
    # year, paper id, institution, type, year
    # .result-item-source

    # initialize an empty dataframe
    source_data <- data.frame(
                     paper_id = character(),
                     source = character(),
                     type = character(),
                     year = integer(),
                     day  = character(),
                     location = character()
    )

    # dc_type will bring us to right function to parse
    dc_type <- urltools::param_get(url, "dc_type")

    if (is.na(dc_type)) {
        source_data_txt <- get_item_source(webpage)
    } else {
        if (dc_type == "media" | dc_type == "other") {
            source_data_txt <- get_result_item_source(webpage, url)
        } else {
            source_data_txt <- get_item_source(webpage)
        }
    }

    if (length(source_data_txt) != 0) {
        # pre-processing. split at \n
        source_data <- data.frame(do.call('rbind', source_data_txt),
                                      stringsAsFactors = FALSE)
        if (dc_type == "media") {
            source_data <- data.frame(paper_id = as.character(source_data[, 1]),
                                      source   = as.character(source_data[, 4]),
                                      type     = as.character(rep("Media", nrow(source_data))),
                                      year     = as.character(rep("", nrow(source_data))),
                                      day      = as.character(source_data[, 5]),
                                      location = as.character(source_data[, 6]),
                                      stringsAsFactors = FALSE)

        } else if (dc_type == "other") {
            source_data <- data.frame(paper_id = as.character(rep("", nrow(source_data))),
                                      source   = as.character(rep("", nrow(source_data))),
                                      type     = as.character(rep("Other", nrow(source_data))),
                                      year     = as.character(rep("", nrow(source_data))),
                                      day      = as.character(rep("", nrow(source_data))),
                                      location = as.character(rep("", nrow(source_data))),
                                      stringsAsFactors = FALSE)

        } else {  # dc-type = all others
            # force data types
            source_data <- data.frame(paper_id = as.character(source_data[, 2]),
                                      source   = as.character(source_data[, 3]),
                                      type     = as.character(source_data[, 4]),
                                      year     = as.character(source_data[, 5]),
                                      day      = as.character(rep("", nrow(source_data))),
                                      location = as.character(rep("", nrow(source_data))),
                                      stringsAsFactors = FALSE)
            # remove dash from year
            source_data$year <- as.integer(gsub("-", "", source_data$year))
        }
    }

    # Let's have a look at the paper source data
    source_data
}


get_result_item_authors <- function(webpage, url) {
    dc_type <- urltools::param_get(url, "dc_type")

    if (dc_type == "media") {
        # dc-type = "media" doesn't have authors. fill with blanks
        result_item <- get_result_item(webpage, url)
        result_item_txt <- rep("", length(result_item))
    } else {
        # dc-type = "other" and the rest do contain "result-item-authors" class
        #author1_data_html <- html_nodes(webpage, '.result-item-author:nth-child(1)')
        result_item <- html_nodes(webpage, '.result-item-authors')
        result_item_txt <- html_text(result_item)
        result_item_txt <- trimws(gsub("\n", "", result_item_txt))
    }
    return(result_item_txt)
}


#' @importFrom rvest html_nodes html_text
read_author <- function(webpage, url) {

    dc_type <- urltools::param_get(url, "dc_type")

    # author data: define empty dataframe
    author_data <- data.frame(author_data = character())

    author_data_txt <- get_result_item_authors(webpage, url)

    if (length(author_data_txt) != 0 ) {
        # data pre-processing
        author_data <- data.frame(author_data = as.character(author_data_txt),
                                   stringsAsFactors = FALSE)
    }
    return(author_data)
}
