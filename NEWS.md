# pcapi 0.2.1 (2022-05-03)

* Minor bug fixes to error messages in `post_to_standardize()`, 
  `post_to_transformation()` and `post_to_use()`.

# pcapi 0.2.0 (2022-04-28)

* Included new function `post_to_standardize()`.
* Minor bug fixes. 

# pcapi 0.0.2 (2022-03-07)

* Version bump to 0.1.0.
* Small fixes of rare issues in `post_to_cid()`.
* Added logo.

# pcapi 0.0.2 (2022-02-04)

* Re-writing of `post_to_cid()` and `post_to_property()`.
* New functions `post_to_transformation()` and `post_to_use()` to retrieve 
  transformation products and use categories, respectively. 
* Improved sanity-checking for PubChem CIDs. 

# pcapi 0.0.1

* Implemented two functions: `post_to_cid()` and `post_to_property`.
* `post_to_cid()` supports InChI, InChIKey, names (and synonyms), SMILES and 
  SDF. 
* Added tests and coverage.
* Added a `NEWS.md` file to track changes to the package.
