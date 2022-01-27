#' @title POST PubChem CIDs to Retrieve Their Properties
#' @description This function performs a query to retrieve properties for
#'   PubChem CIDs.
#' @param cid (Integer) PubChem CID(s) as single integer or a vector of
#'   integers.
#' @param property (Character) Properties to retrieve as single character or
#'   vector of characters. Defaults to \code{"all"}. See Details for all
#'   available properties.
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided PubChem CIDs
#'   and properties and then performs a query. If successful, a list with the
#'   available properties will be returned.
#'
#'   Supported properties include \code{"MolecularFormula"},
#'   \code{"MolecularWeight"}, \code{"CanonicalSMILES"},
#'   \code{"IsomericSMILES"}, \code{"InChI"}, \code{"InChIKey"},
#'   \code{"IUPACName"}, \code{"Title"}, \code{"XLogP"}, \code{"ExactMass"},
#'   \code{"MonoisotopicMass"}, \code{"TPSA"}, \code{"Complexity"},
#'   \code{"Charge"}, \code{"HBondDonorCount"}, \code{"HBondAcceptorCount"},
#'   \code{"RotatableBondCount"}, \code{"HeavyAtomCount"},
#'   \code{"IsotopeAtomCount"}, \code{"AtomStereoCount"},
#'   \code{"DefinedAtomStereoCount"}, \code{"UndefinedAtomStereoCount"},
#'   \code{"BondStereoCount"}, \code{"DefinedBondStereoCount"},
#'   \code{"UndefinedBondStereoCount"}, \code{"CovalentUnitCount"},
#'   \code{"Volume3D"}, \code{"XStericQuadrupole3D"},
#'   \code{"YStericQuadrupole3D"}, \code{"ZStericQuadrupole3D"},
#'   \code{"FeatureCount3D"}, \code{"FeatureAcceptorCount3D"},
#'   \code{"FeatureDonorCount3D"}, \code{"FeatureAnionCount3D"},
#'   \code{"FeatureCationCount3D"}, \code{"FeatureRingCount3D"},
#'   \code{"FeatureHydrophobeCount3D"}, \code{"ConformerModelRMSD3D"},
#'   \code{"EffectiveRotorCount3D"}, \code{"ConformerCount3D"}, and
#'   \code{"Fingerprint2D"}. The default, \code{"all"}, retrieves all listed
#'   properties.
#' @return Returns a list.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' cid <- 2244
#' post_to_properties(cid)
#' }
#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_properties <- function(cid, property = "all", json = FALSE) {

  cid <- as.integer(cid)

  if (sum(sapply(cid, .check_cid)) < length(cid)) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid CID.",
          "Details" = NA_character_
        )
      )
    )
  }

  if (sum(sapply(property, .check_property)) < length(property)) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid property.",
          "Details" = NA_character_
        )
      )
    )
  }

  if (isFALSE(.check_json(json))) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid JSON.",
          "Details" = NA_character_
        )
      )
    )
  }

  if (length(cid) > 1L) {
    cid <- paste(cid, collapse = ",")
  }

  if (property == "all") {

    property <- paste(
      "MolecularFormula",
      "MolecularWeight",
      "CanonicalSMILES",
      "IsomericSMILES",
      "InChI",
      "InChIKey",
      "IUPACName",
      "Title",
      "XLogP",
      "ExactMass",
      "MonoisotopicMass",
      "TPSA",
      "Complexity",
      "Charge",
      "HBondDonorCount",
      "HBondAcceptorCount",
      "RotatableBondCount",
      "HeavyAtomCount",
      "IsotopeAtomCount",
      "AtomStereoCount",
      "DefinedAtomStereoCount",
      "UndefinedAtomStereoCount",
      "BondStereoCount",
      "DefinedBondStereoCount",
      "UndefinedBondStereoCount",
      "CovalentUnitCount",
      "Volume3D",
      "XStericQuadrupole3D",
      "YStericQuadrupole3D",
      "ZStericQuadrupole3D",
      "FeatureCount3D",
      "FeatureAcceptorCount3D",
      "FeatureDonorCount3D",
      "FeatureAnionCount3D",
      "FeatureCationCount3D",
      "FeatureRingCount3D",
      "FeatureHydrophobeCount3D",
      "ConformerModelRMSD3D",
      "EffectiveRotorCount3D",
      "ConformerCount3D",
      "Fingerprint2D",
      sep = ","
    )

  }

  if (length(property) > 1L) {
    property <- paste(property, collapse = ",")
  }

  # define url building blocks
  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
  input <- "compound/cid"
  operation <- paste("property", property, sep = "/")

  # compose url
  url <- paste(prolog, input, operation, sep = "/")

  # define header
  header <- list(
    "Content-Type" = "application/x-www-form-urlencoded",
    "Accept" = "application/json"
  )

  # assemble POST fields
  fields <- paste("cid", cid, sep = "=")

  # create new cURL handle
  handle <- curl::new_handle()

  # specify POST request
  curl::handle_setopt(handle, customrequest = "POST", postfields = fields)

  # set cURL header
  curl::handle_setheaders(handle, .list = header)

  # retrieve results
  result <- curl::curl_fetch_memory(url, handle)

  # decode content
  content <- rawToChar(result$content)

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)
  }

  # return content
  content

}
