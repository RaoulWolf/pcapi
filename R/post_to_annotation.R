source <- "NORMAN Suspect List Exchange"
heading <- "ATC Code"

post_to_annotation <- function(source, heading, json = FALSE, extract = TRUE) {

  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug_view"
  input <- "annotations/heading"

  url <- paste(prolog, input, sep = "/")

  # define header
  header <- list("Accept" = "application/json")

  # assemble POST fields
  fields <- paste(
    paste("source", utils::URLencode(source), sep = "="),
    paste("heading_type", "Compound", sep = "="),
    paste("heading", utils::URLencode(heading), sep = "="),
    paste("page", 1L, sep = "="),
    paste("response_type", "display", sep = "="),
    sep = "&"
  )

  # create new cURL handle
  handle <- curl::new_handle()

  # specify POST request
  curl::handle_setopt(handle, customrequest = "POST", postfields = fields)

  # set cURL header
  curl::handle_setheaders(handle, .list = header)

  # ensure volume limitation
  Sys.sleep(0.2)

  # retrieve results
  result <- curl::curl_fetch_memory(url, handle)

  # decode content
  content <- rawToChar(result$content)

  # transform content
  if (!json) {
    content <- jsonlite::fromJSON(content)

    if (extract) {
      content <- unlist(
        sapply(
          content$Annotations$Annotation$Data,
          FUN = function(x) { unique(x$Value$StringWithMarkup) }
        ),
        use.names = FALSE
      )
    }
  }

  content

}
