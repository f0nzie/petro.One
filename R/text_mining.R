custom_stopwords <- NULL
# custom_stopwords <- get(load(file = system.file("data", "stopwords.rda", package = "petro.One")))

#' @title A TermDocumentMatrix corpus objects
#' @description Transforms a document into a VCorpus TermDocumentMatrix object
#' plus additional calculated matrix, row sums and words frequency objects
#' @param df a dataframe with paper results
#' @return a list
#' @importFrom tm VCorpus VectorSource tm_map content_transformer
#' TermDocumentMatrix removeWords stopwords
#' @importFrom utils data
#' @export
get_term_document_matrix <- function(df) {
    vdocs <- VCorpus(VectorSource(df$book_title))
    # vdocs <- tm_map(vdocs, content_transformer(enc2utf8))
    # vdocs <- tm_map(vcorpus, PlainTextDocument)
    #Create the toSpace content transformer
    toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern," ",
                                                                      x))})
    # Apply it for substituting the regular expression given in one of the former answers by " "
    vdocs <- tm_map(vdocs, toSpace,"[^[:graph:]]")
    vdocs <- tm_map(vdocs, content_transformer(tolower))
    vdocs <- tm_map(vdocs, removeWords, stopwords("english"))
    data("stopwords", envir = environment())
    vdocs <- tm_map(vdocs, removeWords, custom_stopwords)

    tdm <- TermDocumentMatrix(vdocs)

    tdm.matrix <- as.matrix(tdm)
    tdm.rs <- sort(rowSums(tdm.matrix), decreasing=TRUE)
    tdm.df <- data.frame(word = names(tdm.rs), freq = as.integer(tdm.rs),
                         stringsAsFactors = FALSE)
    tdm_list = list(tdm = tdm, matrix = tdm.matrix, rowsums = tdm.rs, freq = tdm.df)
    tdm_list
}

#' @title Word Frequency Dataframe
#' @description Returns a dataframe of words vs frequency
#' @param df a dataframe with paper results
#' @export
term_frequency <- function(df, gram.min = 1, gram.max = 1) {
    # tibble::as.tibble(get_term_document_matrix(df)$freq)
    term_frequency_n_grams(df, gram.min, gram.max)
}


#' @title Plot a word cloud
#' @description Plots a cloud plot of words where the size of the words is
#' determined by their frequency
#' @param df A dataframe with paper results
#' @param max.words the maximum words to process
#' @param min.freq the minimum frequency of words allowed
#' @param ... other parameters
#' @importFrom wordcloud wordcloud
#' @export
plot_wordcloud <- function(df, ..., max.words = 200, min.freq = 50) {
    tdm.df <- term_frequency(df)
    # tdm.df <- df
    wordcloud(words = tdm.df$word, freq = tdm.df$freq,
                         min.freq = min.freq,
              max.words=max.words, random.order=FALSE, rot.per=0.35,
              colors = RColorBrewer::brewer.pal(8, "Dark2"))
}


#' @title Find the frequency for two or more words together
#' @description Use this function when trying to find frequency of two or more words
#' @param df a dataframe with paper results
#' @param gram.min minimum amount of words together
#' @param gram.max maximum amount of words together
#' @param mc.cores number of cores
#' @param stemming apply stemming by default
#' @param more_stopwords a vector of additional stop words
#'
#' @importFrom tm VCorpus VectorSource tm_map content_transformer
#' TermDocumentMatrix removeWords stopwords stripWhitespace removePunctuation
#' @importFrom RWeka NGramTokenizer Weka_control
#' @importFrom utils data
#' @importFrom tm stemDocument
#' @export
term_frequency_n_grams <- function(df, gram.min = 2, gram.max = 2,
                                   mc.cores = 2,
                                   stemming = TRUE,
                                   more_stopwords = NULL) {

    vdocs <- VCorpus(VectorSource(df$book_title))
    vdocs <- tm_map(vdocs, stripWhitespace)
    vdocs <- tm_map(vdocs, removePunctuation)
    vdocs <- tm_map(vdocs, content_transformer(tolower))
    vdocs <- tm_map(vdocs, removeWords, stopwords("english"))
    vdocs <- tm_map(vdocs, removeWords, custom_stopwords)  # from data

    # apply more stopwords
    if (!is.null(more_stopwords))
        vdocs <- tm_map(vdocs, removeWords, more_stopwords)  # more stopwords

    # apply stemming
    if (stemming)
        vdocs <- tm_map(vdocs, stemDocument, language = "english")

    tdm   <- TermDocumentMatrix(vdocs)

    tdm.matrix <- as.matrix(tdm)
    tdm.rs <- sort(rowSums(tdm.matrix), decreasing=TRUE)
    tdm.df <- data.frame(word = names(tdm.rs), freq = as.integer(tdm.rs),
                         stringsAsFactors = FALSE)

    options(mc.cores = mc.cores)

    twogramTokenizer <- function(x) {
        NGramTokenizer(x, Weka_control(min=gram.min, max=gram.max))
    }

    tdm2 <- TermDocumentMatrix(vdocs,
                               control=list(tokenize=twogramTokenizer))

    tdm2.matrix <- as.matrix(tdm2)
    tdm2.rs <- sort(rowSums(tdm2.matrix), decreasing=TRUE)
    tdm2.df <- data.frame(word = names(tdm2.rs), freq = tdm2.rs, stringsAsFactors = FALSE)
    tibble::as.tibble(tdm2.df)
}




#' @title Plot frequency distribution with horizontal bara
#' @description SHows a bar plot with words on the y-axis and frequency on the x-axis
#' @param df a dataframe with paper results
#' @param min.freq minimum frequency of the words to be plotted
#' @importFrom ggplot2 ggplot geom_bar xlab coord_flip aes ylab xlab
#' @importFrom stats reorder
#' @export
plot_bars <- function(df, gram.min = 1, gram.max = 1, min.freq = 25) {
    tdm2.df <- term_frequency(df, gram.min, gram.max)
    # tdm2.df <- df
    freq <- tdm2.df$freq
    word <- tdm2.df$word
    p2 <- ggplot(subset(tdm2.df, freq > min.freq), aes(x=reorder(word, freq), y=freq)) +
        geom_bar(stat = "identity") +
        xlab("Terms") + ylab("Count") +
        coord_flip()

    print(p2)
}

#' @title Plot a relationship diagram with weights
#' @description Plots a diagram with relationships between words. The lines
#' that link the terms are weighted according to how often the connect together
#' @param df a dataframe with paper results
#' @param min.freq minimum frequency of the words to be plotted
#' @param threshold correlation threshold
#' @param ... additional parameters
#' @importFrom tm findFreqTerms
#' @importFrom graphics plot
#' @export
plot_relationships <- function(df, ..., min.freq = 25, threshold = 0.10) {
    TDM <- get_term_document_matrix(df)
    tdm <- TDM$tdm

    #inspect frequent words
    freq.terms <- findFreqTerms(tdm, lowfreq = min.freq)
    plot(tdm, term = freq.terms, corThreshold = threshold, weighting = T)
}


#' @title Plot a dendrogram
#' @description Plots a clustering diagram of terms
#' @param df a dataframe with paper results
#' @importFrom tm removeSparseTerms
#' @importFrom stats hclust dist
#' @importFrom graphics plot
#' @export
plot_cluster_dendrogram <- function(df) {
    tdm <- get_term_document_matrix(df)$tdm

    tdm.rst <- removeSparseTerms(tdm, 0.93)

    # for a different look try substituting: method="ward.D"
    d <- dist(tdm.rst, method="euclidian")
    fit <- hclust(d=d, method="complete")
    plot(fit, hang = 1)
}




#' Get papers for top "N" terms
#'
#' Indicate the top terms from which we want to extract papers.
#' For instance, if we want the papers for the top 10 terms, we set top_terms = 10.
#'
#' @param papers a dataframe with papers
#' @param tdm_matrix a Term Document Matrix
#' @param top_terms top 10, or top 20, etc.
#' @param terms a term or vector of terms to get papers from
#' @param verbose set to TRUE to show progress
#'
#' @importFrom dplyr filter %>%
#' @export
get_top_term_papers <- function(papers, tdm_matrix, top_terms, terms = NULL, verbose = FALSE) {
    # prevent no visible binding for global variables
    word <- NULL; freq <- NULL; book_title <- NULL; keyword <- NULL

    tdm.rs <- sort(rowSums(tdm_matrix), decreasing = TRUE)
    tdm.freq <- data.frame(word = names(tdm.rs), freq = tdm.rs, stringsAsFactors = FALSE)

    if (is.null(terms))
        tdm.freq <- head(tdm.freq, top_terms)  # select top # of rows
    else {
        tdm.freq <- tdm.freq %>%
            filter(word %in% terms)
    }

    row.names(tdm.freq) <- NULL

    # make the words the rows, the docs the columns
    tdtm_matrix <- t(tdm_matrix)          # transpose the matrix
    dtm.df <- as.data.frame(tdtm_matrix)  # convert to dataframe

    # iterate through the tdm frequency dataframe and get the papers for indices
    df_cum <- data.frame()        # accumulator
    for (i in 1:nrow(tdm.freq)) {
        w <- tdm.freq$word[i]
        f <- tdm.freq$freq[i]

        indices <- which(dtm.df[w] > 0)  # get indices
        if (verbose) {
            cat(sprintf("%-25s %3d \t", w, f))
            cat(indices, "\n")
        }
        df <- papers[indices, ]          # get papers
        df$word <- w                     # add variable word
        df$freq <- f                     # add variable frequency
        df_cum <- rbind(df, df_cum)      # cumulative dataframe

    }
    df_cum <- df_cum[with(df_cum, order(-freq)), ]             # sort by frequency
    subset(df_cum, select = c(word, freq, book_title:keyword)) # select columns
}
