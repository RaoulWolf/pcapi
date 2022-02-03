#' @importFrom curl curl_fetch_memory handle_setopt new_handle
#' @importFrom jsonlite fromJSON toJSON
#' @export
post_to_transformation <- function(cid, json = FALSE) {

  # sanity-check cid
  if (isFALSE(.check_cid(cid))) {
    stop("Invalid CID.", call. = FALSE)
  }

  # ensure cid
  cid <- as.integer(cid)

  # set format
  format <- "JSON"

  # define URL
  url <- "https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi"

  # assemble POST query
  query <- jsonlite::toJSON(
    list(
      "download" = "*",
      "collection" = "transformations",
      "where" = list(
        "ands" = data.frame("cid" = as.character(cid))),
      "order" = I(paste("relevancescore", "desc", sep = ",")),
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

  # ensure volume limitation
  Sys.sleep(0.2)

  # retrieve results
  result <- curl::curl_fetch_memory(url, handle)

  # decode content
  content <- rawToChar(result$content)

  # check status
  if (result$status_code != 200L) {
    content <- jsonlite::fromJSON(content)
    warning(content$Fault$Message, call. = FALSE)

    if (!json) {
      return(list())
    } else {
      return(NA_character_)
    }
  }

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)

    if (length(content) > 0L) {
      content <- transform(
        content,
        predecessorcid = as.integer(predecessorcid),
        successorcid = as.integer(successorcid)
      )
    }
  }

  # return content
  content

}
