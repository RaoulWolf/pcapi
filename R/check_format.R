.check_format <- function(format) {

  if (is.null(format)) {
    FALSE
  } else if (
    !(any(tolower(format) %in%
          c("inchi", "inchikey", "name", "sdf", "smiles")))
    ) {
    FALSE
  } else {
    TRUE
  }

}
