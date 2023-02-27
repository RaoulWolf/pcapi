#' @title POST PubChem CIDs to Retrieve Their Properties
#' @description This function performs a query to retrieve properties for
#'   PubChem CIDs.
#' @param cid (Integer.) PubChem CID(s) as single integer or a vector of
#'   integers.
#' @param property (Character.) Properties to retrieve as single character or
#'   vector of characters. This is case-sensitive! Defaults to \code{"all"}.
#'   See Details for all available properties.
#' @param json (Logical.) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided PubChem CIDs
#'   and properties and then performs a query. If successful, a data.frame with
#'   the available properties will be returned.
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
#' @return Returns an data frame or a character string, depending on the value
#'   of \code{json}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' cid <- 2244
#' post_to_property(cid)
#' }
#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_property <- function(cid, property = "all", json = FALSE) {

  # sanity-check cid
  if (missing(cid) || sum(sapply(cid, .check_cid)) < length(cid)) {
    stop("Invalid CID.", call. = FALSE)
  }

  # sanity-check property
  if (sum(sapply(property, .check_property)) < length(property)) {
    stop("Invalid property.", call. = FALSE)
  }

  # sanity-check json
  if (!.check_json(json)) {
    stop("Invalid JSON.", call. = FALSE)
  }

  # ensure cid
  cid <- as.integer(cid)

  # treat cid
  if (length(cid) > 1L) {
    cid <- paste(cid, collapse = ",")
  }

  # combine properties
  if (length(property) == 1L && property == "all") {
    property <- c(
      "MolecularFormula", "MolecularWeight", "CanonicalSMILES",
      "IsomericSMILES", "InChI", "InChIKey", "IUPACName", "Title", "XLogP",
      "ExactMass", "MonoisotopicMass", "TPSA", "Complexity", "Charge",
      "HBondDonorCount", "HBondAcceptorCount", "RotatableBondCount",
      "HeavyAtomCount", "IsotopeAtomCount", "AtomStereoCount",
      "DefinedAtomStereoCount", "UndefinedAtomStereoCount", "BondStereoCount",
      "DefinedBondStereoCount", "UndefinedBondStereoCount",
      "CovalentUnitCount", "Volume3D", "XStericQuadrupole3D",
      "YStericQuadrupole3D", "ZStericQuadrupole3D", "FeatureCount3D",
      "FeatureAcceptorCount3D", "FeatureDonorCount3D", "FeatureAnionCount3D",
      "FeatureCationCount3D", "FeatureRingCount3D", "FeatureHydrophobeCount3D",
      "ConformerModelRMSD3D", "EffectiveRotorCount3D", "ConformerCount3D",
      "Fingerprint2D"
    )
  }

  # treat property
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
  header <- list("Accept" = "application/json")

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

  # check status
  if(result$status_code != 200L) {
    if(json) {
      return(content)
    } else {
      content <- jsonlite::fromJSON(content)
      warning(content$Fault$Message, call. = FALSE)
      return(data.frame())
    }
  }

  # transform content
  if(!json) {
    content <- jsonlite::fromJSON(content)
    content <- content$PropertyTable$Properties

    if("MolecularWeight" %in% colnames(content)) {
      content <- transform(
        content,
        MolecularWeight = as.double(MolecularWeight)
      )
    }

    if("ExactMass" %in% colnames(content)) {
      content <- transform(
        content,
        ExactMass = as.double(ExactMass)
      )
    }

    if("MonoisotopicMass" %in% colnames(content)) {
      content <- transform(
        content,
        MonoisotopicMass = as.double(MonoisotopicMass)
      )
    }
  }

  # return content
  content

}
