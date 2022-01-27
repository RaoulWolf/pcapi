.check_json <- function(json) {

  if (is.na(json) || is.null(json)) {
    FALSE
  } else if (!is.logical(json)) {
    FALSE
  } else {
    TRUE
  }

}
