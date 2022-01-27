#' @source https://pubchemdocs.ncbi.nlm.nih.gov/pug-rest-tutorial
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt
#'   new_handle
#' @importFrom jsonlite fromJSON
#' @export
post_to_cids <- function(x, format, json = FALSE) {

  # sanity-check format
  if (isFALSE(.check_format(format))) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid format.",
          "Details" = NA_character_
        )
      )
    )
  }

  # sanity-check inchi
  if (tolower(format) == "inchi" && isFALSE(.check_inchi(x))) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid InChI.",
          "Details" = NA_character_
        )
      )
    )
  }

  # sanity-check inchikey
  if (tolower(format) == "inchikey" && isFALSE(.check_inchikey(x))) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid InChIKey.",
          "Details" = NA_character_
        )
      )
    )
  }

  # sanity-check smiles
  if (tolower(format) == "smiles" && isFALSE(.check_smiles(x))) {
    return(
      list(
        "Fault" = list(
          "Code" = NA_character_,
          "Message" = "Invalid SMILES.",
          "Details" = NA_character_
        )
      )
    )
  }

  # sanity-check json
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
  }

  # return content
  content

}
