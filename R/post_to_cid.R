#' @title POST Information to Retrieve PubChem CIDs
#' @description This function performs a query to retrieve PubChem CIDs for
#'   different inputs.
#' @param x (Character) Input to the search, must match with the format.
#' @param format (Character) Format type of the input. This is not case
#'   sensitive. Must be lower case! See Details for supported formats.
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided inputs and
#'   then performs a query. If successful, a integer vector with the available
#'   PubChem CID(s) will be returned.
#'
#'   Supported formats include \code{"InChI"}, \code{"InChIKey"},
#'   \code{"Name"}, \code{"SDF"}, and \code{"SMILES"}.
#' @return Returns an integer (or possibly vector thereof) or a character
#'   string, depending on the value of \code{json}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples
#' \dontrun{
#' name <- "Atrazine"
#' post_to_cid(name, format = "Name")
#' }
#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_cid <- function(x, format, json = FALSE) {

  # sanity-check x
  if (missing(x) || is.na(x) || length(x) > 1L) {
    stop("Invalid x.", call. = FALSE)
  }

  # sanity-check format
  if (missing(format) || !.check_format(format)) {
    stop("Invalid format.", call. = FALSE)
  }

  # sanity-check inchi
  if (tolower(format) == "inchi" && !.check_inchi(x)) {
    stop("Invalid InChI.", call. = FALSE)
  }

  # sanity-check inchikey
  if (tolower(format) == "inchikey" && !.check_inchikey(x)) {
    stop("Invalid InChIKey.", call. = FALSE)
  }

  # sanity-check smiles
  if (tolower(format) == "smiles" && !.check_smiles(x)) {
    stop("Invalid SMILES.", call. = FALSE)
  }

  # sanity-check json
  if (!.check_json(json)) {
    stop("Invalid JSON.", call. = FALSE)
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

  # check status
  if (result$status_code != 200L) {
    content <- jsonlite::fromJSON(content)
    warning(content$Fault$Message, call. = FALSE)

    if (!json) {
      return(NA_integer_)
    } else {
      return(NA_character_)
    }
  }

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)
    content <- content$IdentifierList$CID

    if (is.null(content) || content == 0L) {
      return(NA_integer_)
    }
  }

  # return content
  content

}
