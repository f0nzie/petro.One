

load_synonyms <- function() {
    synfile <- system.file("extdata", "synonyms.txt", package = "petro.One")
    custom_synonyms <- utils::read.table(file = synfile, header = TRUE, sep = "|",
                                  stringsAsFactors = FALSE)
    names(custom_synonyms) <- c("original", "replace_by")
    custom_synonyms
}

syn_df <- load_synonyms()

change_to_synonym <- function(title) {
    title <- tolower(title)
    for (k in seq_len(nrow(syn_df))) {
        if (grepl(syn_df$original[[k]], title)) {
            #cat(syn_df$original[[k]])
            x <- gsub(syn_df$original[[k]], syn_df$replace_by[[k]], title, fixed = TRUE)
        }
    }
    x
}

