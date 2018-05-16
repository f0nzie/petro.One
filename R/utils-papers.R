#' Remove duplicate papers by a variable
#'
#' Duplicates are removed in a dataframe containing papers
#' @param df dataframe of papers
#' @param by variable
#' @importFrom dplyr distinct_ arrange desc
#' @export
remove_duplicates_by <- function(df, by = "book_title") {
    if (!all(names(df) %in% c("book_title", "paper_id", "dc_type", "authors",
                              "year", "source", "keyword" )))
        stop("not a *papers* dataframe")

    df %>%
        distinct_(by, .keep_all = TRUE) %>%    # keep rest of variables
        arrange(desc(year))
}
