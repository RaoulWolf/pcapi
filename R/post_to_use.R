#' @title POST a PubChem CID to Retrieve Its Use Categories
#' @description This function performs a query to retrieve known use categories
#'   for a PubChem CID.
#' @param cid (Integer) PubChem CID as single integer.
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided PubChem CID
#'   and then performs a query. If successful, a data frame with the available
#'   use categories will be returned.
#' @return Returns an data frame or a character string, depending on the value
#'   of \code{json}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' cid <- 2256L
#' post_to_use(cid)
#' }
#' @importFrom curl curl_fetch_memory handle_setopt new_handle
#' @importFrom jsonlite fromJSON toJSON
#' @export
#' @importFrom curl curl_fetch_memory handle_setopt new_handle
#' @importFrom jsonlite fromJSON toJSON
#' @export
post_to_use <- function(cid, json = FALSE) {

  # sanity-check cid
  if (missing(cid) || !.check_cid(cid)) {
    stop("Invalid CID.", call. = FALSE)
  }

  # sanity-check json
  if (!.check_json(json)) {
    stop("Invalid JSON.", call. = FALSE)
  }

  # ensure cid
  cid <- as.integer(cid)

  # set format
  format <- "JSON"

  # define URL
  prolog <- "https://pubchem.ncbi.nlm.nih.gov"
  operation <- "sdq/sdqagent.cgi"
  url <- paste(prolog, operation, sep = "/")

  # assemble POST query
  query <- jsonlite::toJSON(
    list(
      "download" = "*",
      "collection" = "cpdat",
      "where" = list("ands" = data.frame("cid" = as.character(cid))),
      "order" = I(paste("category", "asc", sep = ",")),
      "start" = 1L,
      "limit" = 10000000L
    ),
    auto_unbox = TRUE
  )

  # assemble POST fields
  fields <- paste(
    paste("infmt", tolower(format), sep = "="),
    paste("outfmt", tolower(format), sep = "="),
    paste("query", query, sep = "="),
    sep = "&"
  )

  # create new cURL handle
  handle <- curl::new_handle()

  # specify POST request
  curl::handle_setopt(handle, customrequest = "POST", postfields = fields)

  # retrieve results
  result <- curl::curl_fetch_memory(url, handle)

  # decode content
  content <- rawToChar(result$content)

  # check status
  if (result$status_code != 200L) {
    content <- jsonlite::fromJSON(content)
    warning(content$Fault$Message, call. = FALSE)

    if (!json) {
      return(data.frame())
    } else {
      return(NA_character_)
    }
  }

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)

    if (length(content) == 0L) {
      return(data.frame())
    } else {
      content <- transform(content, cid = as.integer(cid))
    }
  }

  # return content
  content

}
