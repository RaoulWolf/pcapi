#' @title POST SMILES, InChI or SDF to Retrieve Standardized Compound
#'   Information
#' @description This function performs a query to retrieve standardized
#'   compound information for a provided SMILES, InChI or SDF
#' @param x (Character) A SMILES, InChI or SDF as single character string.
#' @param format (Character) The format of the provided string. Has to be one
#'   of "SMILES", "InChI" or "SDF".
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided SMILES or
#'   InChI (but not SDF) and then performs a query. If successful, a data.frame
#'   with the following properties will be returned:  \code{"compound_id_type"},
#'   \code{"compound_cid"}, \code{"iupac_inchi"},
#'   \code{"iupac_inchikey"}, \code{"openeye_iso_smiles"}, and
#'   \code{"compound_parent"}.
#' @return Returns an data frame or a character string, depending on the value
#'   of \code{json}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' x <- paste(
#'   "CC(=O)OC1=C(Cl)C=CC=C1C(=O)[O-]",
#'   "CC(=O)OC1=C(Cl)C=CC=C1C(=O)[O-]",
#'   "[Ca+2]",
#'   sep = "."
#' )
#' post_to_standardize(x, format = "SMILES")
#' }
#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial

#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_standardize <- function(x, format, json = FALSE) {

  if (missing(x) || length(x) > 1L) {
    stop("Invalid x.", call. = FALSE)
  }

  if (missing(format) || !.check_format(format)) {
    stop("Invalid format.", call. = FALSE)
  }

  if (!(tolower(format) %in% c("smiles", "inchi", "sdf"))) {
    stop("Unsupported format.", call. = FALSE)
  }

  if (tolower(format) == "inchi" && !.check_inchi(x)) {
    stop("Invalid InChI.", call. = FALSE)
  }

  if (tolower(format) == "smiles" && !.check_smiles(x)) {
    stop("Invalid SMILES.", call. = FALSE)
  }

  if (!.check_json(json)) {
    stop("Invalid JSON.", call. = FALSE)
  }

  format <- tolower(format)

  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
  input <- paste("standardize", format, sep = "/")
  operation <- "JSON"

  url <- paste(prolog, input, operation, sep = "/")

  header <- list("Content-Type" = "multipart/form-data; boundary=AaB03x")

  fields <- paste(
    "--AaB03x",
    paste0("Content-Disposition: form-data; name=\"", format, "\""),
    "Content-Type: text/plain",
    "",
    x,
    "--AaB03x--",
    sep = "\r\n"
  )

  handle <- curl::new_handle()

  curl::handle_setopt(handle, customrequest = "POST", postfields = fields)

  curl::handle_setheaders(handle, .list = header)

  result <- curl::curl_fetch_memory(url, handle)

  content <- rawToChar(result$content)

  if (!json) {

    content <- jsonlite::fromJSON(content)

    if (result$status_code != 200L) {
      warning(content$Fault$Message, call. = FALSE)
      return(data.frame())
    }

    content <- data.frame(
      "compound_id_type" = content$PC_Compounds$id$type,
      "compound_cid" = content$PC_Compounds$id$id$cid,
      "iupac_inchi" = sapply(
        content$PC_Compounds$props,
        FUN = function(x) {
          x$value$sval[1]
        },
        USE.NAMES = FALSE
      ),
      "iupac_inchikey" = sapply(
        content$PC_Compounds$props,
        FUN = function(x) {
          x$value$sval[2]
        },
        USE.NAMES = FALSE
      ),
      "openeye_iso_smiles" = sapply(
        content$PC_Compounds$props,
        FUN = function(x) {
          x$value$sval[3]
        },
        USE.NAMES = FALSE
      ),
      "compound_parent" = sapply(
        content$PC_Compounds$props,
        FUN = function(x) {
          if (is.null(x$value$slist[[4]])) {
            NA_character_
          } else {
            x$value$slist[[4]]
          }
        },
        USE.NAMES = FALSE
      ),
      stringsAsFactors = FALSE
    )

  }

  content

}
