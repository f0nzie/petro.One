## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ------------------------------------------------------------------------
library(petro.One)

## ---- 5-keywords---------------------------------------------------------
# provide two different set of keywords to combine as vectors
major  <- c("water injection", "water flooding")
minor  <- c("machine-learning", "artificial intelligence")
lesser <- c("neural networks")

result_object <- join_keywords(major, minor, lesser, get_papers = TRUE)
result_object

## ------------------------------------------------------------------------
# save findings
# save the three objects as one
papers <- result_object
wat_inj_ml_1 <- petro.One:::as_named_list(major, minor, lesser, papers)
save(wat_inj_ml_1, file = paste0("wat_inj_ml_1", ".rda"))

# load previous save
load(file = paste0("wat_inj_ml_1", ".rda"))
papers <- wat_inj_ml_1$papers
papers

## ------------------------------------------------------------------------
paper_results <- run_papers_search(major, minor, lesser,
                                   get_papers = TRUE,       # return with papers
                                   verbose = FALSE,         # show progress
                                   len_keywords = 4,        # naming the data file
                                   allow_duplicates = FALSE) # by paper title and id

## ------------------------------------------------------------------------
names(paper_results)

## ------------------------------------------------------------------------
# provide two different set of keywords to combine as vectors
m  <- c("water injection", "water flooding")
n  <- c("machine-learning", "machine learning", "intelligent")
p  <- c("neural network", "SVM", "genetic")
q  <- c("algorithm")

paper_results_9 <- run_papers_search(m, n, p, q,
                                   get_papers = TRUE,       # return with papers
                                   verbose = FALSE,         # show progress
                                   len_keywords = 4,        # naming the data file
                                   allow_duplicates = FALSE) # by paper title and id

paper_results_9$papers

## ---- 6-keywords---------------------------------------------------------
# provide two different set of keywords to combine as vectors
maj <- c("waterflooding")
min <- c("machine-learning", "artificial intelligence")
les <- c("algorithm")
anr <- c("data-mining", "data-driven")

paper_results_5 <- run_papers_search(maj, min, les, anr, 
                                   get_papers = TRUE,       # return with papers
                                   verbose = FALSE,         # show progress
                                   len_keywords = 4,        # naming the data file
                                   allow_duplicates = FALSE) # by paper title and id

paper_results_5$keywords

## ------------------------------------------------------------------------
paper_results_5$search_keywords

