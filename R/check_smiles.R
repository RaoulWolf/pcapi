.check_smiles <- function(smiles) {

  if (is.na(smiles) || is.null(smiles)) {
    FALSE
  } else if (!grepl(pattern = "[[:alpha:]]", smiles)) {
    FALSE
  } else {
    TRUE
  }

}
