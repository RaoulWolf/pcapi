.check_inchi <- function(inchi) {

  if (is.na(inchi) || is.null(inchi)) {
    FALSE
  } else if (!grepl(pattern = "[[:alpha:]]", inchi)) {
    FALSE
  } else if (!grepl(pattern = "InChI=", inchi)) {
    FALSE
  } else {
    TRUE
  }

}
