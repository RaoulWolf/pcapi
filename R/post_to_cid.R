#' @title POST Information to Retrieve PubChem CIDs
#' @description This function performs a query to retrieve PubChem CIDs for
#'   different inputs.
#' @param x (Character) Input to the search, must match with the format.
#' @param format (Character) Format type of the input. This is not case
#'   sensitive. Must be lower case! See Details for supported formats.
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @param extract (Logical) Should the (non-JSON) result be extracted, i.e.,
#'   unlisted? Defaults to \code{TRUE}.
#' @details The function performs a sanity check on the provided inputs and
#'   then performs a query. If successful, a list with the available
#'   PubChem CIDs will be returned.
#'
#'   Supported formats include \code{"InChI"}, \code{"InChIKey"},
#'   \code{"Name"}, \code{"SDF"}, and \code{"SMILES"}.
#' @return Returns a vector or a list, depending on the value of \code{extract}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' x <- "Aspirin"
#' post_to_cid(x, format = "name")
#' }
#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_cid <- function(x, format, json = FALSE, extract = TRUE) {

  # sanity-check extract
  if (isFALSE(.check_extract(extract))) {

    res <- "Invalid extract."

    return(res)

  }

  # sanity-check format
  if (isFALSE(.check_format(format))) {

    res <- list(
      "Fault" = list(
        "Code" = NA_character_,
        "Message" = "Invalid format.",
        "Details" = NA_character_
      )
    )

    if (extract) {
      res <- res$Fault$Message
    }

    return(res)

  }

  # sanity-check inchi
  if (tolower(format) == "inchi" && isFALSE(.check_inchi(x))) {

    res <- list(
      "Fault" = list(
        "Code" = NA_character_,
        "Message" = "Invalid InChI.",
        "Details" = NA_character_
      )
    )

    if (extract) {
      res <- res$Fault$Message
    }

    return(res)

  }

  # sanity-check inchikey
  if (tolower(format) == "inchikey" && isFALSE(.check_inchikey(x))) {

    res <- list(
      "Fault" = list(
        "Code" = NA_character_,
        "Message" = "Invalid InChIKey.",
        "Details" = NA_character_
      )
    )

    if (extract) {
      res <- res$Fault$Message
    }

    return(res)
  }

  # sanity-check smiles
  if (tolower(format) == "smiles" && isFALSE(.check_smiles(x))) {

    res <- list(
      "Fault" = list(
        "Code" = NA_character_,
        "Message" = "Invalid SMILES.",
        "Details" = NA_character_
      )
    )

    if (extract) {
      res <- res$Fault$Message
    }

    return(res)

  }

  # sanity-check json
  if (isFALSE(.check_json(json))) {

    res <- list(
      "Fault" = list(
        "Code" = NA_character_,
        "Message" = "Invalid JSON.",
        "Details" = NA_character_
      )
    )

    if (extract) {
      res <- res$Fault$Message
    }

    return(res)

  }

  # ensure format
  format <- tolower(format)

  # define url building blocks
  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
  input <- paste("compound", format, sep = "/")
  operation <- "cids"

  # compose url
  url <- paste(prolog, input, operation, sep = "/")

  # define header
  header <- list(
    "Content-Type" = "multipart/form-data; boundary=AaB03x",
    "Accept" = "application/json"
  )

  # assemble POST fields
  fields <- paste(
    "--AaB03x",
    paste0("Content-Disposition: form-data; name=\"", format, "\""),
    "Content-Type: text/plain",
    "",
    x,
    "--AaB03x--",
    sep = "\r\n"
  )

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
    if (extract) {
      content <- content$IdentifierList$CID
    }
  }

  # return content
  content

}