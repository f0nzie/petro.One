

#' @importFrom dplyr rename mutate
get_dc_type_raw <- function(webpage) {

    dc_type_0 <- html_nodes(webpage, '.result-item') %>%
        html_attr("data-type") %>%
        trimws %>%         # remove blanks
        head(., -1)        # discard last row

    data_itemid <- get_data_itemid(webpage)

    if (ncol(data_itemid) > 2) {
        dc_type <- data_itemid %>%
            rename(dc_type_1 = X1, paper_id = X2, dc_type_2 = X3, sup = X4) %>%
            mutate(x1x3 = ifelse(dc_type_1 == dc_type_2, TRUE, FALSE)) %>%
            mutate(dc_type = ifelse(dc_type_2 %in% "SUPPLEMENTARY", "media", dc_type_1)) %>%
            mutate(dc_type = ifelse(dc_type_1 %in% "book", "chapter", dc_type))
    } else if(ncol(data_itemid) == 0) {
        dc_type <- tibble::tibble(dc_type = character(), paper_id = character())
                                  # authors = character(), source = character(), year = integer())

    } else {
        dc_type <- data_itemid %>%
            rename(dc_type = X1, paper_id = X2)
    }

    # number of columns of result is not a multiple of vector length (arg 154)
    tibble::as.tibble(cbind(dc_type_0, dc_type))
}


get_data_itemid <- function(webpage) {
    data_itemid <- html_nodes(webpage, '.result-item') %>%
        html_attr("data-itemid") %>%      # extract data-itemid
        gsub("data-cite-id=", "", .) %>%
        trimws %>%
        head(., -1)

    data_itemid <- strsplit(data_itemid, "/")
    data.frame(t(sapply(data_itemid, '[', 1:max(sapply(data_itemid, length)))),
               stringsAsFactors = FALSE)
}


get_dc_type <- function(webpage) {
    dc_type_raw <- get_dc_type_raw(webpage)
    dc_type_raw$dc_type
}


get_paper_id <- function(webpage) {
    dc_type_raw <- get_dc_type_raw(webpage)
    dc_type_raw$paper_id
}

get_book_title <- function(webpage) {
    html_nodes(webpage, '.result-item') %>%
        html_nodes(".book-title") %>%
        html_text %>%
        gsub("\n", "", .) %>%
        trimws
}


get_result_item_authors <- function(webpage) {
    html_nodes(webpage, '.result-item') %>%
        # html_nodes(".result-item-authors")
        html_nodes(".highlighted") %>%
        html_text %>%
        #gsub("\n", "", .) %>%
        trimws %>%
        strsplit("\n") %>%
        lapply(., trimws) %>%
        lapply(., function(x) x[!x %in% ""])  # remove a blank from a list

}


get_authors <- function(webpage) {
    # @param x called by apply function
    join_authors <- function(x, y) {
        nm1 <- if (grepl("[,.]", y[[x]][1])) y[[x]][1] else "NA"
        nm2 <- if (grepl("[,.]", y[[x]][2]) & nm1 != "NA") y[[x]][2] else "NA"
        nm3 <- if (grepl("[,.]", y[[x]][3]) & nm2 != "NA") y[[x]][3] else "NA"
        nm4 <- if (grepl("[,.]", y[[x]][4]) & nm3 != "NA") y[[x]][4] else "NA"
        nm5 <- if (grepl("[,.]", y[[x]][5]) & nm4 != "NA") y[[x]][5] else "NA"
        nm6 <- if (grepl("[,.]", y[[x]][6]) & nm5 != "NA") y[[x]][6] else "NA"
        nm7 <- if (grepl("[,.]", y[[x]][7]) & nm6 != "NA") y[[x]][7] else "NA"
        nm8 <- if (grepl("[,.]", y[[x]][8]) & nm7 != "NA") y[[x]][8] else "NA"
        authors <- paste(nm1, nm2, nm3, nm4, nm5, nm6, nm7, nm8, sep = "|")
        authors <- strsplit(authors, "|", fixed = TRUE)
        authors <- lapply(authors, function(x) x[!x %in% "NA"] )  # remove a blank from a list
        authors <- sapply(authors, paste, collapse = " | ")
        #if (is_author(authors)) authors else "unknown"
    }

    item_authors <- get_result_item_authors(webpage)
    data.frame(authors = sapply(seq_along(item_authors), join_authors, item_authors),
               stringsAsFactors = FALSE)
}

get_year <- function(webpage) {
    f <- function(x) {
        if (!any(sapply(x, function(y) grepl(y, pattern = "- [0-9].", perl = TRUE))))
            NA
        else {
            as.integer(trimws(gsub("-", "",grep(x, pattern = "- [0-9].", perl = TRUE, value = TRUE))))
        }

    }
    item_authors <- get_result_item_authors(webpage)
    data.frame(year = sapply(item_authors, f))
}

get_source <- function(webpage) {
    f <- function(x) {
        if (!any(sapply(x, function(y) grepl(y, pattern = "^[A-Z]+$", perl = TRUE))))
            NA
        else
            grep(x, pattern = "^[A-Z]+$", perl = TRUE, value = TRUE)
    }
    item_authors <- get_result_item_authors(webpage)
    sapply(item_authors, f)
}


get_papers_from_result_item <- function(url) {
    webpage <- xml2::read_html(url)

    dc_type    <- get_dc_type(webpage)
    book_title <- get_book_title(webpage)
    paper_id   <- get_paper_id(webpage)
    authors    <- get_authors(webpage)
    year       <- get_year(webpage)
    source     <- get_source(webpage)
    tibble::as.tibble(cbind(book_title, paper_id, dc_type, authors, year, source))
}
