## 20171102
Kurt Hornik <Kurt.Hornik@r-project.org>
3:05 PM (2 hours ago)
to alfonso.reyes, CRAN 
    Dear maintainer,
    Pls see the problems shown on
    <https://cran.r-project.org/web/checks/check_results_petro.One.html>:
    Can you pls fix as necessary?
Best,
-k


## 20171027
Note from Uwe Ligges:
    Simply delete the Author/Maintainer fields from your master sources.
    R CMD build will create these from the Authoras@R field.
    Best,
    Uwe Ligges



## Resubmission
This is a resubmission. In this version I have:

## 0.1.0
* Thanks, please add an URL for OnePetro in your description text in the form <http:...> or <https:...> with angle brackets for auto-linking and no space after 'http:' and 'https:'.

* Please write complete sentensec:
    * Thousand of papers on oil and gas live in OnePetro.
    * 'There  is some statistics' -> There are some statistics
    * 'data mining' --> data mining tools???
    * 'word cloud' --> word cloud plot???

* Your title suggests that this package provides text mining tools. Is that correct?


* Please add examples in your Rd-files. Something like
    \examples{
           examples for users:
           executable in < 5 sec
           for checks
           \dontshow{
                  examples for checks:
                  executable in < 5 sec together with the examples above
                  not shown to users
           }
           donttest{
                  further examples for users (not used for checks)
           }
    }

Please fix and resubmit.  Best, Swetlana Herbrandt
