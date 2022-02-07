.check_cid <- function(cid) {

  if (length(cid) > 1L) {
    FALSE
  } else if (is.na(suppressWarnings(as.integer(cid))) || is.null(cid)) {
    FALSE
  } else if (is.logical(cid)) {
    FALSE
  } else if (grepl(pattern = "\\.", cid)) {
    FALSE
  } else if (sign(as.integer(cid)) != 1) {
    FALSE
  } else {
    TRUE
  }

}
