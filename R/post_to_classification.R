post_to_classification <- function(cid, json = FALSE) {

  # ensure cid
  cid <- as.integer(cid)

  # set format
  format <- "JSON"

  # define URL
  prolog <- "https://pubchem.ncbi.nlm.nih.gov"
  operation <- "classification/cgi/classifications.fcgi"
  url <- paste(prolog, operation, sep = "/")

  # assemble POST fields
  fields <- paste(
    paste("format", tolower(format), sep = "="),
    paste("hid", 101L, sep = "="),
    paste("search_uid_type", "cid", sep = "="),
    paste("search_uid", cid, sep = "="),
    paste("search_type", "list", sep = "="),
    # paste("response_type", "save", sep = "="),
    # paste("response_basename", paste("Classification_HID_101_CID", cid, sep = "_"), sep = "="),
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
      return(list())
    } else {
      return(NA_character_)
    }
  }

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)
    content <- View(content$Hierarchies$Hierarchy)
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

?format=json&hid=101&search_uid_type=cid&search_uid=15099986&search_type=list&response_type=save&response_basename=Classification_HID_101_CID_15099986
