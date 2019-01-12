

get_authors <- function() {
    data.frame(authors = sapply(1:100, join_authors), stringsAsFactors = FALSE)
}


#' @param x called by apply function
join_authors <- function(x) {
    nm1 <- if (grepl("[,.]", item_authors[[x]][1])) item_authors[[x]][1] else "NA"
    nm2 <- if (grepl("[,.]", item_authors[[x]][2]) & nm1 != "NA") item_authors[[x]][2] else "NA"
    nm3 <- if (grepl("[,.]", item_authors[[x]][3]) & nm2 != "NA") item_authors[[x]][3] else "NA"
    nm4 <- if (grepl("[,.]", item_authors[[x]][4]) & nm3 != "NA") item_authors[[x]][4] else "NA"
    nm5 <- if (grepl("[,.]", item_authors[[x]][5]) & nm4 != "NA") item_authors[[x]][5] else "NA"
    nm6 <- if (grepl("[,.]", item_authors[[x]][6]) & nm5 != "NA") item_authors[[x]][6] else "NA"
    nm7 <- if (grepl("[,.]", item_authors[[x]][7]) & nm6 != "NA") item_authors[[x]][7] else "NA"
    nm8 <- if (grepl("[,.]", item_authors[[x]][8]) & nm7 != "NA") item_authors[[x]][8] else "NA"
    authors <- paste(nm1, nm2, nm3, nm4, nm5, nm6, nm7, nm8, sep = "|")
    authors <- strsplit(authors, "|", fixed = TRUE)
    authors <- lapply(authors, function(x) x[!x %in% "NA"] )  # remove a blank from a list
    authors <- sapply(authors, paste, collapse = " | ")
    #if (is_author(authors)) authors else "unknown"
}



# how many times a character repeats
# we wantr to find only occurance of only one comma. It means it is not a name
# and probably empty. Names have at least two commas
character_repeats <- function(char_vector, the_char = ",") {
    sapply(gregexpr(",", char_vector), function(x) length(x))
}


# logical. if the count os greater than one, it is a name.
# if the count is one or zero, then
is_author <- function(author_vector) {
    stopifnot(!is.numeric(author_vector))
    repeats <- character_repeats(author_vector)
    ifelse(repeats > 1, TRUE, FALSE)
}



get_year <- function(item_authors) {
    f <- function(x) {
        if (!any(sapply(x, function(y) grepl(y, pattern = "- [0-9].", perl = TRUE))))
            NA
        else {
            as.integer(trimws(gsub("-", "",grep(x, pattern = "- [0-9].", perl = TRUE, value = TRUE))))
        }

    }

    data.frame(year = sapply(item_authors, f))
}



get_source <- function(item_authors) {
    f <- function(x) {
        if (!any(sapply(x, function(y) grepl(y, pattern = "^[A-Z]+$", perl = TRUE))))
            NA
        else
            grep(x, pattern = "^[A-Z]+$", perl = TRUE, value = TRUE)
    }

    sapply(item_authors, f)
}
