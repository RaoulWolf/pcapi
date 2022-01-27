.check_inchikey <- function(inchikey) {

  if (is.na(inchikey) || is.null(inchikey)) {
    FALSE
  } else if (!grepl(pattern = "[[:upper:]]", inchikey)) {
    FALSE
  } else if (nchar(inchikey) != 27L) {
    FALSE
  } else if (length(unlist(strsplit(inchikey, split = "-"))) != 3L) {
    FALSE
  } else if (nchar(unlist(strsplit(inchikey, split = "-"))[1]) != 14L) {
    FALSE
  } else if (nchar(unlist(strsplit(inchikey, split = "-"))[2]) != 10L) {
    FALSE
  } else if (nchar(unlist(strsplit(inchikey, split = "-"))[3]) != 1L) {
    FALSE
  } else {
    TRUE
  }

}
