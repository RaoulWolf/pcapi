
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pcapi

<!-- badges: start -->

[![R-CMD-check](https://github.com/RaoulWolf/pcapi/workflows/R-CMD-check/badge.svg)](https://github.com/RaoulWolf/pcapi/actions)
[![Codecov test
coverage](https://codecov.io/gh/RaoulWolf/pcapi/branch/master/graph/badge.svg)](https://app.codecov.io/gh/RaoulWolf/pcapi?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

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

## Installation

You can install the development version of pcapi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
remotes::install_github("RaoulWolf/pcapi")
```

## Examples

The following examples show the functionality of two API functions of
pcapi: `post_to_cid()` and `post_to_property()`.

This is an example which shows you how to get the PubChem CID for
aspirin:

``` r
library(pcapi)

aspirin_cid <- post_to_cid("Aspirin", format = "name")

str(aspirin_cid)
#> List of 1
#>  $ IdentifierList:List of 1
#>   ..$ CID: int 2244
```

Here is an example which shows you how to get the properties for a
PubChem CID. In this case, again, for aspirin:

``` r
aspirin_properties <- post_to_property(aspirin_cid$IdentifierList$CID)

str(aspirin_properties$PropertyTable$Properties)
#> 'data.frame':    1 obs. of  42 variables:
#>  $ CID                     : int 2244
#>  $ MolecularFormula        : chr "C9H8O4"
#>  $ MolecularWeight         : chr "180.16"
#>  $ CanonicalSMILES         : chr "CC(=O)OC1=CC=CC=C1C(=O)O"
#>  $ IsomericSMILES          : chr "CC(=O)OC1=CC=CC=C1C(=O)O"
#>  $ InChI                   : chr "InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-5H,1H3,(H,11,12)"
#>  $ InChIKey                : chr "BSYNRYMUTXBXSQ-UHFFFAOYSA-N"
#>  $ IUPACName               : chr "2-acetyloxybenzoic acid"
#>  $ XLogP                   : num 1.2
#>  $ ExactMass               : chr "180.04225873"
#>  $ MonoisotopicMass        : chr "180.04225873"
#>  $ TPSA                    : num 63.6
#>  $ Complexity              : int 212
#>  $ Charge                  : int 0
#>  $ HBondDonorCount         : int 1
#>  $ HBondAcceptorCount      : int 4
#>  $ RotatableBondCount      : int 3
#>  $ HeavyAtomCount          : int 13
#>  $ IsotopeAtomCount        : int 0
#>  $ AtomStereoCount         : int 0
#>  $ DefinedAtomStereoCount  : int 0
#>  $ UndefinedAtomStereoCount: int 0
#>  $ BondStereoCount         : int 0
#>  $ DefinedBondStereoCount  : int 0
#>  $ UndefinedBondStereoCount: int 0
#>  $ CovalentUnitCount       : int 1
#>  $ Volume3D                : int 136
#>  $ XStericQuadrupole3D     : num 3.86
#>  $ YStericQuadrupole3D     : num 2.45
#>  $ ZStericQuadrupole3D     : num 0.89
#>  $ FeatureCount3D          : int 5
#>  $ FeatureAcceptorCount3D  : int 3
#>  $ FeatureDonorCount3D     : int 0
#>  $ FeatureAnionCount3D     : int 1
#>  $ FeatureCationCount3D    : int 0
#>  $ FeatureRingCount3D      : int 1
#>  $ FeatureHydrophobeCount3D: int 0
#>  $ ConformerModelRMSD3D    : num 0.6
#>  $ EffectiveRotorCount3D   : int 3
#>  $ ConformerCount3D        : int 10
#>  $ Fingerprint2D           : chr "AAADccBwOAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAAABAAAAGgAACAAADASAmAAyDoAABgCIAiDSCAACCAAkIAAIiAEGCMgMJzaENRqCe2C"| __truncated__
#>  $ Title                   : chr "Aspirin"
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
