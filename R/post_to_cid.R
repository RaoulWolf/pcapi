#' @title POST Information to Retrieve PubChem CIDs
#' @description This function performs a query to retrieve PubChem CIDs for
#'   different inputs.
#' @param x (Character.) Input to the search, must match with the format.
#' @param format (Character.) Format type of the input. This is not case
#'   sensitive. Must be lower case! See Details for supported formats.
#' @param domain (Character.) Must be either \code{"compound"} (default) or
#'   \code{"substance"}.
#' @param json (Logical.) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided inputs and
#'   then performs a query. If successful, an integer vector with the available
#'   PubChem CID(s) will be returned for the \code{"compound"} domain, or a
#'   list of PubChem SID(s) and CID(s) for the \code{"substance"} domain.
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
post_to_cid <- function(x, format, domain = "compound", json = FALSE) {

  # sanity-check x
  if (missing(x) || is.na(x) || length(x) > 1L) {
    warning("Invalid x.", call. = FALSE)
    return(NA_integer_)
  }

  # sanity-check format
  if (missing(format) || !.check_format(format)) {
    warning("Invalid format.", call. = FALSE)
    return(NA_integer_)
  }

  # sanity-check inchi
  if (tolower(format) == "inchi" && !.check_inchi(x)) {
    warning("Invalid InChI.", call. = FALSE)
    return(NA_integer_)
  }

  # sanity-check inchikey
  if (tolower(format) == "inchikey" && !.check_inchikey(x)) {
    warning("Invalid InChIKey.", call. = FALSE)
    return(NA_integer_)
  }

  # sanity-check smiles
  if (tolower(format) == "smiles" && !.check_smiles(x)) {
    warning("Invalid SMILES.", call. = FALSE)
    return(NA_integer_)
  }

  if (!(domain %in% c("compound", "substance"))) {
    warning("Invalid domain.", call. = FALSE)
    return(NA_integer_)
  }

  # sanity-check json
  if (!.check_json(json)) {
    warning("Invalid JSON.", call. = FALSE)
    return(NA_integer_)
  }

  # ensure format
  domain <- tolower(domain)
  format <- tolower(format)

  # define url building blocks
  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
  input <- paste(domain, format, sep = "/")
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
  if(result$status_code != 200L) {
    if(json) {
      return(content)
    } else {
      content <- jsonlite::fromJSON(content)
      warning(content$Fault$Message, call. = FALSE)
      return(NA_integer_)
    }
  }

  # transform content
  if(!json) {
    content <- jsonlite::fromJSON(content)
    if(domain == "compound") {
      content <- content$IdentifierList$CID
    } else if(domain == "substance") {
      content <- unique(
        unlist(content$InformationList$Information$CID, use.names = FALSE)
      )
    }
  }

  # return content
  content

}
