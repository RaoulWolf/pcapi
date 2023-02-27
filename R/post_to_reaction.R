#' @title POST a PubChem CID to Retrieve Its Known Reaction Products
#' @description This function performs a query to retrieve known reaction
#'   products for a PubChem CID.
#' @param cid (Integer) PubChem CID as single integer.
#' @param collection (Character) Which reaction collection should be returned?
#'   Must be one of \code{"rhea"} or \code{"pathwayreaction"}.
#' @param json (Logical) Should the result be returned as JSON? Defaults to
#'   \code{FALSE}.
#' @details The function performs a sanity check on the provided PubChem CID
#'   and collection, then performs a query. If successful, a data frame with
#'   the available reaction products will be returned.
#' @return Returns an data frame or a character string, depending on the value
#'   of \code{json}.
#' @author Raoul Wolf (\url{https://github.com/RaoulWolf/})
#' @examples \dontrun{
#' cid <- 2256
#' collection <- "rhea"
#' post_to_reaction(cid, collection)
#' }
#' @importFrom curl curl_fetch_memory handle_setopt new_handle
#' @importFrom jsonlite fromJSON toJSON
#' @export
post_to_reaction <- function(cid, collection, json = FALSE) {

  # sanity-check cid
  if (missing(cid) || !.check_cid(cid)) {
    stop("Invalid CID.", call. = FALSE)
  }

  # sanity-check json
  if (!.check_json(json)) {
    stop("Invalid JSON.", call. = FALSE)
  }

  if (
    missing(collection) ||
    !(tolower(collection) %in% c("rhea", "pathwayreaction"))
  ) {
    stop("Invalid collection.", call. = FALSE)
  }

  # ensure cid
  cid <- as.integer(cid)

  # ensure collection
  collection <- tolower(collection)

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
      "collection" = collection,
      "where" = list("ands" = data.frame("cid" = as.character(cid))),
      "order" = ifelse(
        test = collection == "rhea",
        yes = I(paste("rhid", "asc", sep = ",")),
        no = I(paste("relevancescore", "desc", sep = ","))),
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

    if (length(content) == 0L) {
      return(data.frame())
    } else {
      if (collection == "rhea") {
        content <- transform(
          content,
          rhid = as.integer(rhid),
          otherdirections = lapply(otherdirections, FUN = "as.integer"),
          cidsreactant = lapply(cidsreactant, FUN = "as.integer"),
          cidsproduct = lapply(cidsproduct, FUN = "as.integer")
        )
      } else {
        content <- transform(
          content,
          cidsreactant = lapply(cidsreactant, FUN = "as.integer"),
          cidsproduct = lapply(cidsproduct, FUN = "as.integer")
        )
      }
    }
  }

  # return content
  content

}

