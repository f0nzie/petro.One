
#' @title Unpack an example
#' @description Examples are zipped to save disk space and prevent R complaining
#' while creating the package
#' @param which_one example number to use
#' @importFrom utils unzip
#' @export
use_example <- function(which_one = NULL) {
    if (is.null(which_one)) stop("an example number must be supplied")
    if (which_one == 1) unzip_this("3_pages_conference.zip")
    else stop("example not implemented")
}


unzip_this <- function(a_zip_file) {
    unzip(paste(system.file("extdata", package = "petro.One"),
                a_zip_file, sep = "/"))
}


expect_equal_scale <- function(object, expected, ..., tolerance_pct) {
    tolerance <- tolerance_pct
    scale <- object
    testthat::expect_equal(object, expected, tolerance, scale, check.attributes = TRUE)
}



#' Take objects and create a list using their names
#'
#' This avoids retyping the name of the object as in a list
#'
#' @param ... additional parameters
#' @importFrom stats setNames
#' @keywords internal
as_named_list <- function(...) {
    if (length(as.character( match.call()[-1])) < 1)
        stop("you must supply at least one object name")
    nl <- setNames( list(...), as.character( match.call()[-1]) )
    nl
}
