## ----message=FALSE-------------------------------------------------------
library(petro.One)
library(tm)
library(tibble)

use_example(1)

p1 <- onepetro_page_to_dataframe("neural_network-s0000r1000.html")
p2 <- onepetro_page_to_dataframe("neural_network-s1000r1000.html")
p3 <- onepetro_page_to_dataframe("neural_network-s2000r1000.html")
p4 <- onepetro_page_to_dataframe("neural_network-s3000r1000.html")

nn_papers <- rbind(p1, p2, p3, p4)
nn_papers

## ------------------------------------------------------------------------
get_papers_count("neural_network-s0000r1000.html")
get_papers_count("neural_network-s1000r1000.html")
get_papers_count("neural_network-s3000r1000.html")

## ------------------------------------------------------------------------
vdocs <- VCorpus(VectorSource(nn_papers$book_title))
vdocs <- tm_map(vdocs, content_transformer(tolower))      # to lowercase
vdocs <- tm_map(vdocs, removeWords, stopwords("english")) # remove stopwords

## ------------------------------------------------------------------------
tdm <- TermDocumentMatrix(vdocs)

tdm.matrix <- as.matrix(tdm)
tdm.rs <- sort(rowSums(tdm.matrix), decreasing=TRUE)
tdm.df <- data.frame(word = names(tdm.rs), freq = tdm.rs, stringsAsFactors = FALSE)
as.tibble(tdm.df)                          # prevent long printing of dataframe

## ----warning=FALSE, message=FALSE----------------------------------------
library(wordcloud)

set.seed(1234)
wordcloud(words = tdm.df$word, freq = tdm.df$freq, min.freq = 50,
          max.words=200, random.order=FALSE, rot.per=0.35,
          colors=brewer.pal(8, "Dark2"))

