install.packages(c("devtools", "testthat"))


install.packages(c('xml2', 'rvest', 'tm', 'wordcloud', 'urltools', 'dplyr',
                   'ggplot2', 'RWeka', 'RColorBrewer', 'data.table'), type = 'source')


source("https://bioconductor.org/biocLite.R")
biocLite()
biocLite(c('graph', 'Rgraphviz'))
