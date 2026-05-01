## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.

One note is about the non (still) existing DOI in the CITATION file (I anticipated the DOI for the package).

One note is due to "non-portable file paths" are found. These paths are used to simulate the target path of an API used by the package and to test it via testthat.
