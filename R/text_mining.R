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
    vdocs <- VCorpus(VectorSource(df$title_data))
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
term_frequency <- function(df) {
    tibble::as.tibble(get_term_document_matrix(df)$freq)
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
#' @importFrom tm VCorpus VectorSource tm_map content_transformer
#' TermDocumentMatrix removeWords stopwords stripWhitespace removePunctuation
#' @importFrom RWeka NGramTokenizer Weka_control
#' @importFrom utils data
#' @export
term_frequency_n_grams <- function(df, gram.min = 2, gram.max = 2) {
    vdocs <- VCorpus(VectorSource(df$title_data))
    vdocs <- tm_map(vdocs, content_transformer(tolower))
    vdocs <- tm_map(vdocs, removeWords, stopwords("english"))

    # data("stopwords", envir = environment())
    vdocs <- tm_map(vdocs, removeWords, custom_stopwords)
    vdocs <- tm_map(vdocs, stripWhitespace)
    vdocs <- tm_map(vdocs, removePunctuation)
    tdm   <- TermDocumentMatrix(vdocs)

    tdm.matrix <- as.matrix(tdm)
    tdm.rs <- sort(rowSums(tdm.matrix), decreasing=TRUE)
    tdm.df <- data.frame(word = names(tdm.rs), freq = as.integer(tdm.rs),
                         stringsAsFactors = FALSE)

    options(mc.cores=1)
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
plot_bars <- function(df, min.freq = 25) {
    tdm2.df <- term_frequency(df)
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
