#' Text mining and statistics for OnePetro papers
#' petro.One
#'
#' @name petro.One-package
#' @docType package
NULL




#' @title Discipline and Subject  labels dataset
#' @description dataset containing disciplines and subjects.
#' The purpose is to categorize papers based on the words in their title since
#' OnePetro does not supply keywords or any sort of categorization.
#' File:  disciplines.rda
#' Class: data.frame
#' @docType data
"labels"



#' @title Default custom stop words
#' @description This is a minimal dataset of custom stopwords.
#' You can supply your own stopwords by editing the file stopwords.txt under
#' `extdata` and then importing it.
#' The provided dataset is a basic way to start and eliminate
#' common words from the paper titles during classification.
#'
#' Dataset: stopwords.rda
#'
#' Source:  stopwords.txt
#'
#' @docType data
"custom_stopwords"


#' @title Default synonyms
#' @description Synonyms dataset to prevent repetition of equivalent words
#' during classification. Example: 2D/2-D, cased hole/cased-hole,
#' deep water/deepwater, etc.
#' The first column is for the original word; the second column is for the
#'
#' Dataset: synonyms.rda
#' replacement or standard word.
#'
#' Source:  synonyms.txt
#'
#' @docType data
# 'custom_synonyms'
