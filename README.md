
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pcapi <img src="man/figures/logo.svg" align="right" height="139" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/RaoulWolf/pcapi/workflows/R-CMD-check/badge.svg)](https://github.com/RaoulWolf/pcapi/actions)
[![Codecov test
coverage](https://codecov.io/gh/RaoulWolf/pcapi/branch/master/graph/badge.svg)](https://app.codecov.io/gh/RaoulWolf/pcapi?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

> A [ZeroPM](https://zeropm.eu/) R package

The goal of the pcapi package is to provide a minimal and lightweight
interface to the [PubChem](https://pubchem.ncbi.nlm.nih.gov/) API
services.

The dependencies of pcapi are kept at a bare minimum:
[curl](https://cran.r-project.org/web/packages/curl/index.html) for
handling the API requests and
[jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)
to parse data from JSON format.

Currently, the following formats can be used to retrieve PubChem CIDs:
InChI, InChIKey, names (including synonyms), SDF, and SMILES.

### But what about [webchem](https://docs.ropensci.org/webchem/)?

First of all, [webchem](https://docs.ropensci.org/webchem/) is a
fantastic package - please use it! webchem offers support for many
different API services, not only PubChem’s API service. However, there
are issues related to the way webchem sets up the queries against
PubChem API services, which can result in errors. This has been
observed, for example, when SMILES or InChI strings contain backslashes,
or an MOL/SDF is used as input. With pcapi, these problems are
(hopefully) solved. Additionally, pcapi will continuously implement some
of the lesser known functionalities, such as the retrival of
transformation products.

## Installation

You can install the development version of pcapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
remotes::install_github("RaoulWolf/pcapi")
```

## Functions

PubChem’s API services are vast and flexible. Not all functionality will
be available immediately, and some functionalities may not be worth it
to implement. That being said, the goal of pcapi is to provide a
satisfying user-experience, covering the most relevant functionalities
of the API. The following table gives an overview of the available
functions, as well as their expected inputs and outputs.

| Function                   | Expected input                                   | Output                                |
|:---------------------------|:-------------------------------------------------|:--------------------------------------|
| `post_to_cid()`            | InChI, InChIKey, MOL, name, SDF, SMILES, synonym | integer vector of PubChem CID(s)      |
| `post_to_property()`       | PubChem CID                                      | data frame of properties              |
| `post_to_transformation()` | PubChem CID                                      | data frame of transformation products |
| `post_to_use()`            | PubChem CID                                      | data frame of use categories          |
| `post_to_standardize()`    | InChI, SDF, SMILES                               | data frame of standardized compounds  |

## Examples

The following examples show the functionality of two API functions of
pcapi: `post_to_cid()` and `post_to_property()`.

This is an example which shows you how to get the PubChem CID for the
herbicide [atrazine](https://en.wikipedia.org/wiki/Atrazine):

``` r
library(pcapi)

atrazine_cid <- post_to_cid("atrazine", format = "name")
atrazine_cid
#> [1] 2256
```

Using this PubChem CID, we can now get all available descriptors and
physico-chemical properties for atrazine:

``` r
atrazine_properties <- post_to_property(atrazine_cid, property = "all")
str(atrazine_properties)
#> 'data.frame':    1 obs. of  42 variables:
#>  $ CID                     : int 2256
#>  $ MolecularFormula        : chr "C8H14ClN5"
#>  $ MolecularWeight         : num 216
#>  $ CanonicalSMILES         : chr "CCNC1=NC(=NC(=N1)Cl)NC(C)C"
#>  $ IsomericSMILES          : chr "CCNC1=NC(=NC(=N1)Cl)NC(C)C"
#>  $ InChI                   : chr "InChI=1S/C8H14ClN5/c1-4-10-7-12-6(9)13-8(14-7)11-5(2)3/h5H,4H2,1-3H3,(H2,10,11,12,13,14)"
#>  $ InChIKey                : chr "MXWJVTOOROXGIU-UHFFFAOYSA-N"
#>  $ IUPACName               : chr "6-chloro-4-N-ethyl-2-N-propan-2-yl-1,3,5-triazine-2,4-diamine"
#>  $ XLogP                   : num 2.6
#>  $ ExactMass               : num 215
#>  $ MonoisotopicMass        : num 215
#>  $ TPSA                    : num 62.7
#>  $ Complexity              : int 166
#>  $ Charge                  : int 0
#>  $ HBondDonorCount         : int 2
#>  $ HBondAcceptorCount      : int 5
#>  $ RotatableBondCount      : int 4
#>  $ HeavyAtomCount          : int 14
#>  $ IsotopeAtomCount        : int 0
#>  $ AtomStereoCount         : int 0
#>  $ DefinedAtomStereoCount  : int 0
#>  $ UndefinedAtomStereoCount: int 0
#>  $ BondStereoCount         : int 0
#>  $ DefinedBondStereoCount  : int 0
#>  $ UndefinedBondStereoCount: int 0
#>  $ CovalentUnitCount       : int 1
#>  $ Volume3D                : num 158
#>  $ XStericQuadrupole3D     : num 5.3
#>  $ YStericQuadrupole3D     : num 4.27
#>  $ ZStericQuadrupole3D     : num 0.75
#>  $ FeatureCount3D          : int 6
#>  $ FeatureAcceptorCount3D  : int 0
#>  $ FeatureDonorCount3D     : int 2
#>  $ FeatureAnionCount3D     : int 0
#>  $ FeatureCationCount3D    : int 2
#>  $ FeatureRingCount3D      : int 1
#>  $ FeatureHydrophobeCount3D: int 1
#>  $ ConformerModelRMSD3D    : num 0.6
#>  $ EffectiveRotorCount3D   : int 4
#>  $ ConformerCount3D        : int 10
#>  $ Fingerprint2D           : chr "AAADccBzgAAEAAAAAAAAAAAAAAAAAAAAAAAsAAAAAAAAAAABgAAAHAIQAAAACCjBAAQDEAbIEAAgAAAAJAAAAAkAAIABAIAIAACACAAACAAAAAA"| __truncated__
#>  $ Title                   : chr "Atrazine"
```

To get an overview of all transformation products, the PubChem CID can
be used as well:

``` r
atrazine_transformations <- post_to_transformation(atrazine_cid)
str(atrazine_transformations)
#> 'data.frame':    31 obs. of  13 variables:
#>  $ cids             :List of 31
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 135398733
#>   ..$ : int  2256 135408770
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 18831
#>   ..$ : int  2256 18831
#>   ..$ : int  2256 18831
#>   ..$ : int  2256 18831
#>   ..$ : int  2256 135398733
#>   ..$ : int  2256 135510207
#>   ..$ : int  2256 15818023
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 22563
#>   ..$ : int  2256 135398733
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 135510207
#>   ..$ : int  2256 135398733
#>   ..$ : int  2256 13878
#>   ..$ : int  2256 22563
#>  $ predecessor      : chr  "atrazine" "atrazine" "atrazine" "Atrazine" ...
#>  $ predecessorcid   : int  2256 2256 2256 2256 2256 2256 2256 2256 2256 2256 ...
#>  $ transformation   : chr  "Environmental" "Environmental" "Environmental" "Mammalian metabolism" ...
#>  $ successor        : chr  "6-deisopropyl atrazine" "deethylatrazine" "2-hydroxyatrazine" "Ammeline" ...
#>  $ successorcid     : int  13878 22563 135398733 135408770 13878 13878 13878 13878 18831 18831 ...
#>  $ evidencedoi      : chr  "10.1021/acs.est.1c00466" "10.1021/acs.est.1c00466" "10.1021/acs.est.1c00466" "10.5281/zenodo.3827487" ...
#>  $ evidenceref      : chr  "Menger, F. et al (2021); Identification of pesticide transformation products in surface water using suspect scr"| __truncated__ "Menger, F. et al (2021); Identification of pesticide transformation products in surface water using suspect scr"| __truncated__ "Menger, F. et al (2021); Identification of pesticide transformation products in surface water using suspect scr"| __truncated__ "Kearney, P.C., and D. D. Kaufman (eds.) Herbicides: Chemistry, Degredation and Mode of Action. Volumes 1 and 2."| __truncated__ ...
#>  $ sourcecomment    : chr  "10.5281/zenodo.4687924" "10.5281/zenodo.4687924" "10.5281/zenodo.4687924" "HSDB" ...
#>  $ sourcecommentfull:List of 31
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "HSDB is a toxicology database that focuses on the toxicology of potentially hazardous chemicals. See https://pu"| __truncated__
#>   ..$ : chr "Eawag: Swiss Federal Institute for Aquatic Science and Technology (https://www.eawag.ch/en/)"
#>   ..$ : chr "Eawag: Swiss Federal Institute for Aquatic Science and Technology (https://www.eawag.ch/en/)"
#>   ..$ : chr "Eawag: Swiss Federal Institute for Aquatic Science and Technology (https://www.eawag.ch/en/)"
#>   ..$ : chr "Eawag: Swiss Federal Institute for Aquatic Science and Technology (https://www.eawag.ch/en/)"
#>   ..$ : chr "Pesticides Properties DataBase; Lewis, K.A., Tzilivakis, J., Warner, D.J. and Green, A., 2016. An international"| __truncated__
#>   ..$ : chr "Pesticides Properties DataBase; Lewis, K.A., Tzilivakis, J., Warner, D.J. and Green, A., 2016. An international"| __truncated__
#>   ..$ : chr "Pesticides Properties DataBase; Lewis, K.A., Tzilivakis, J., Warner, D.J. and Green, A., 2016. An international"| __truncated__
#>  $ datasetdoi       : chr  "10.5281/zenodo.4687924" "10.5281/zenodo.4687924" "10.5281/zenodo.4687924" "10.5281/zenodo.3827487" ...
#>  $ datasetref       :List of 31
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr  "S78 " " SLUPESTTPS " " Pesticides and TPs from SLU, Sweden"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S68 " " HSDBTPS " " Transformation Products Extracted from HSDB Content in PubChem, validated by LCSB-ECI"
#>   ..$ : chr  "S66 " " EAWAGTPS " " Parent-Transformation Product Pairs from Eawag " " Parent-Transformation Product Pairs from Schollee et al 2017, Eawag."
#>   ..$ : chr  "S66 " " EAWAGTPS " " Parent-Transformation Product Pairs from Eawag " " Parent-Transformation Product Pairs from Schollee et al 2017, Eawag."
#>   ..$ : chr  "S66 " " EAWAGTPS " " Parent-Transformation Product Pairs from Eawag " " Parent-Transformation Product Pairs from Schollee et al 2017, Eawag."
#>   ..$ : chr  "S66 " " EAWAGTPS " " Parent-Transformation Product Pairs from Eawag " " Parent-Transformation Product Pairs from Schollee et al 2017, Eawag."
#>   ..$ : chr  "S60 " " SWISSPEST19 " " Swiss Pesticides and Metabolites from Kiefer et al 2019 " " Swiss Pesticides and Metabolites from Kiefer et al 2019."
#>   ..$ : chr  "S60 " " SWISSPEST19 " " Swiss Pesticides and Metabolites from Kiefer et al 2019 " " Swiss Pesticides and Metabolites from Kiefer et al 2019."
#>   ..$ : chr  "S60 " " SWISSPEST19 " " Swiss Pesticides and Metabolites from Kiefer et al 2019 " " Swiss Pesticides and Metabolites from Kiefer et al 2019."
#>  $ biosystem        : chr  "soil" "soil" "soil" NA ...
```

The use categories can also be retrieved using the PubChem CID:

``` r
atrazine_uses <- post_to_use(atrazine_cid)
str(atrazine_uses)
#> 'data.frame':    11 obs. of  5 variables:
#>  $ category    : chr  "Laboratory supplies" "Landscape/yard -> herbicide" "Landscape/yard -> lawn fertilizer" "biocide" ...
#>  $ cid         : int  2256 2256 2256 2256 2256 2256 2256 2256 2256 2256 ...
#>  $ catogorydesc: chr  "Products specifically used in a laboratory setting, e.g. laboratory diagnostics or consumables, solvents and re"| __truncated__ "Products used to control or kill unwanted plants" "Fertilizers for lawns, including in combination with pest/weed controllers" NA ...
#>  $ source      : chr  "Product Use Category (PUC)" "Product Use Category (PUC)" "Product Use Category (PUC)" "OECD Functional Use" ...
#>  $ cmpdname    : chr  "Atrazine" "Atrazine" "Atrazine" "Atrazine" ...
```

## Acknowledgement

This R package was developed by the EnviData initiative at the
[Norwegian Geotechnical Institute (NGI)](https://www.ngi.no/eng) as part
of the project [ZeroPM: Zero pollution of Persistent, Mobile
substances](https://zeropm.eu/). This project has received funding from
the European Union’s Horizon 2020 research and innovation programme
under grant agreement No 101036756.

------------------------------------------------------------------------

If you find this package useful and can afford it, please consider
making a donation to a humanitarian non-profit organization, such as
[Sea-Watch](https://sea-watch.org/en/). Thank you.
