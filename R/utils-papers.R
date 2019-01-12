#' Remove duplicate papers by a variable
#'
#' Duplicates are removed in a dataframe containing papers
#' @param df dataframe of papers
#' @param by variable
#' @importFrom dplyr distinct_ arrange desc
#' @examples
#' \dontrun{
#' major <- c("data driven")
#' minor <- c("drilling")
#' dd_drilling <- join_keywords(major, minor, get_papers = TRUE, sleep = 3,
#'                              verbose = FALSE)
#' remove_duplicates_by(dd_drilling$papers, by ="paper_id" )
#' }
#' @export
remove_duplicates_by <- function(df, by = "book_title") {
    if (!all(names(df) %in% c("book_title", "paper_id", "dc_type", "authors",
                              "year", "source", "keyword" )))
        stop("not a *papers* dataframe")

    df %>%
        distinct_(by, .keep_all = TRUE) %>%    # keep rest of variables
        arrange(desc(year))
}
