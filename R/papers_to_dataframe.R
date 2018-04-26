
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
    webpage <- read_html(url)
    df_titles  <- read_titles(webpage)
    df_sources <- read_sources(webpage)
    df_author  <- read_author(webpage)

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
read_titles <- function(webpage) {

    # title:  .result-link
    # define empty dataframe
    title_data <- data.frame(title_data = character())

    # Using CSS selectors to scrap the rankings section
    title_data_html <- html_nodes(webpage, '.result-link')

    # Converting the ranking data to text
    title_data_txt <- html_text(title_data_html)

    if (length(title_data_txt) != 0 ) {
        # data pre-processing
        title_data <- trimws(gsub("\n", "",title_data_txt))
        title_data <- data.frame(title_data = as.character(title_data),
                                 stringsAsFactors = FALSE)
    }
    return(title_data)
}


#' @importFrom rvest html_nodes html_text
get_item_source <- function(webpage) {
    # Using CSS selectors to scrap the rankings section
    source_data_html <- html_nodes(webpage, '.result-item-source')

    # Converting the ranking data to text
    html_text(source_data_html)
}



#' @importFrom rvest html_nodes html_text
read_sources <- function(webpage) {
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

    source_data_txt <- get_item_source(webpage)

    # print(source_data_txt)

    if (length(source_data_txt) != 0) {
        # pre-processing. split at \n
        source_data <- data.frame(do.call('rbind', strsplit(as.character(source_data_txt),
                                                            '\n', fixed=TRUE)),
                                  stringsAsFactors = FALSE)
        # print(source_data)
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
    # Let's have a look at the paper source data
    source_data
}

#' @importFrom rvest html_nodes html_text
read_author <- function(webpage) {
    # author #1. define empty dataframe
    author1_data <- data.frame(author1_data = character())

    #Using CSS selectors to scrap the rankings section
    #author1_data_html <- html_nodes(webpage, '.result-item-author:nth-child(1)')
    author1_data_html <- html_nodes(webpage, '.result-item-authors')

    #Converting the ranking data to text
    author1_data_txt <- html_text(author1_data_html)

    if (length(author1_data_txt) != 0 ) {
        # print("author data \n")
        # print(length(author1_data))

        # data pre-processing
        author1_data <- trimws(gsub("\n", "", author1_data_txt))
        author1_data <- data.frame(author1_data = as.character(author1_data),
                                   stringsAsFactors = FALSE)
    }

    #Let's have a look at the rankings
    author1_data
}
