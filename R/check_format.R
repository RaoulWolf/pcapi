.check_format <- function(format) {

  if (is.null(format)) {
    FALSE
  } else if (
    !(any(tolower(format) %in% c("inchi", "inchikey", "name", "smiles")))
    ) {
    FALSE
  } else {
    TRUE
  }

}
