.check_extract <- function(extract) {

  if (is.na(extract) || is.null(extract)) {
    FALSE
  } else if (!is.logical(extract)) {
    FALSE
  } else {
    TRUE
  }

}
