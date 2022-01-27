.check_cid <- function(cid) {

  if (is.na(cid) || is.null(cid)) {
    FALSE
  } else if (sign(cid) != 1) {
    FALSE
  } else {
    TRUE
  }

}
