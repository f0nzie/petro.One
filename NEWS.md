## 0.1.1.9000 20171028
* 

## 0.1.0
* add this line in travis.yml "r: bioc-release" to get packages from BioConductor

## 0.1.0.9018
* remove author and maintainer from Description at suggestion from Uwe Ligges
* removed the R. from the author name
* Returned by CRAN with 2 NOTES
* submitting 0.1.0 to CRAN on 20171026 at 20:00

## 0.1.0.9017
* return a tibble instead of a dataframe in term_frequency
* add example to install from github develop 
* use dataframe instead of term frequency in plot_bars and plot_wordcloud.
* add examples with plot_bars and plot_wordcloud in README

## 0.1.0.9016
* describe examples
* describe OnePetro search URL
* started with a fresh copy of repo to fix problem with version numbers
* gh-pages with develop version now

## 0.1.1.9005= 0.1.0.9015
* update papers count in unit testss
* remove old_travis.yml
* make a fresh copy of the repo to start with right versions

## 0.1.1.9004= 0.1.0.9014
* improve code coverage to 80%
* add tests for multipage.R, custom.R and utils.R
* fix problem with unstructured paper types: other, media and standard.


## 0.1.1.9003 = 0.1.0.9013
* add new params to travis.yml
* add knitr:;kable to README

## 0.1.1.9002 = 0.1.0.9012
* add chunks with code that doesn't show with knitr::kable
* add parameters to codecov.yml

## 0.1.1.9001 = 0.1.0.9011
* 20171015
* add token to covr
* 20171014
* add new function to replace expect_equal with expect_equal_tolerance_pct. each test has now a value of tolerance to allow passing the tests when new papers are added
* replace summary_by with papers_by
* add more unit tests
* improve function that extract the papers count when the paper type selector is disabled
# new function break by pattern
* read_multipage() can loop through thousands of papers metadata now
* dc_type other, standard and media do not show content in standard results page.
* add coverage. 
* add codecov.yml
* add travis.yml
* NEWS sections by version

## 0.1.1.9000 = 0.1.0.9010
* Fix issues found by CRAN.
* Correct spelling as indicated in `cran-comments.md`
* Add link to OnePetro website
* Add examples
* start counter at 9010

## 0.1.0.9006
* release to **CRAN** as v0.1.0
* original tag was 0.1.1. Replaced by 0.1.0.9006 after CRAN return

## 0.1.0.9005

* fix URL in description to make GitHub icon show up in site
* add instructions to install from CRAN
* add link to OnePetro
* improve README description

## 0.1.0.9004
* naming vignettes alphabetically to sort them on the nav bar
* add what's next section in vignette *improving the word cloud*
* do not use numbers at the beginning of the filenames of vignettes
* add vignette `make_wordcloud_02`: improving the word cloud
* add vignette `make_wordcloud_01`: make a word cloud.
* restore deleted folder `inst/out` to allow vignette `thousands_to_dataframe` to write some html files
* new function `use_example` that unzips html files. Too big for CRAN
* zip three html file as zip under extdata
* remove big hmtl files from package
* new notebook about labeling with disciplines extracted from merge multi pages
* move multipage papers "neural network" to classification folder
* revisit custom stopwords. save to package and project folders.
* add PROJHOME variable with project root folder

## 0.1.0.9003
* change name from petroOne to petro.One in all documents
* add badge CRAN
* explain options any and all.

## 0.1.0.9002
* playing with RSelenium to click over the abstract link to get the text.
* Installing a Docker container with Selenium for firfox-standalone.
* Notebooks to play with Rselenium under ./notebooks/01-url_query folder
* new vignette "thousands_to_dataframe" to bind multiple pages into one dataframe. Not all paper types are homogeneous and they return different columns. Until we find the algorithm, we will retrieve papers by a unique document type.
* paper types do not return complete info in first query. It has to be specified in the type combobox. Problem moved to `test_failing.Rmd`
* new vignette `paper_types.Rmd` to show how to obtain papers by document type. The document types that are homogeneous and return in the first query are: conference papers, jornal papers, general papers, presentation papers and chapter papers. Non-homogeneous: other and media types.

## 0.1.0.9001

* use tibbles to prevent long printing of dataframes
* use as.tibble in functions onepetro_page_to_dataframe and summary_by_xxx
* reordering chunks in README
* improve explanation of what to do when we have more than 1000 papers to retrieve

## 0.1.0.9000

* use as.tibble to avoid long printing of dataframes
* show first attempt of splitting paper pages in groups of 1000. Using example of "neural networks" which has 2661 conference-papers. For the time being using one type of papers because other document types have a different number of columns and causes a conflict with the dataframe binding. Working on it.
* build site with pkgdown
* add documentation for datasets
* add tolerance to expect_equal because number of paper keeps growing
* Added a `NEWS.md` file to track changes to the package.
