.test_post_to_all_property <- function(cid) {

  # sanity-check cid
  if (sum(sapply(cid, .check_cid)) < length(cid)) {
    return("Invalid CID.")
  }

  # ensure cid
  cid <- as.integer(cid)

  # treat cid
  if (length(cid) > 1L) {
    cid <- paste(cid, collapse = ",")
  }

  # define properties
  property <- ""

  # define url building blocks
  prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
  input <- "compound/cid"

  # compose url
  url <- paste(prolog, input, sep = "/")

  # define header
  header <- list(
    # "Content-Type" = "application/x-www-form-urlencoded",
    "Accept" = "application/json"
  )

  # assemble POST fields
  fields <- paste(
    paste("cid", cid, sep = "="),
    paste("property", property, sep = "="),
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
  content <- jsonlite::fromJSON(content)

  res <- data.frame(
    "cid" = content$PC_Compounds$id$id,
    "Charge" = content$PC_Compounds$charge,
    check.names = FALSE
  )

  names_vec <- gsub(
    pattern = "[^[:alnum:]]",
    replacement = "",
    ifelse(
      test = is.na(content$PC_Compounds$props[[1]]$urn$name),
      yes = content$PC_Compounds$props[[1]]$urn$label,
      no = paste(
        content$PC_Compounds$props[[1]]$urn$name,
        content$PC_Compounds$props[[1]]$urn$label,
        sep = " "
      )
    )
  )

  integer_list <- lapply(
    content$PC_Compounds$props,
    FUN = \(x) { as.list(x$value$ival) }
  )

  double_list <- lapply(
    content$PC_Compounds$props,
    FUN = \(x) { as.list(x$value$fval) }
  )

  binary_list <- lapply(
    content$PC_Compounds$props,
    FUN = \(x) { as.list(x$value$binary) }
  )

  character_list <- lapply(
    content$PC_Compounds$props,
    FUN = \(x) { as.list(x$value$sval) }
  )

  # sapply(
  #   1:length(cid_vec),
  #   FUN = \(x) {
  #     res <- transform(
  #       res,
  #       names_vec[x] = ifelse(
  #         test = !is.na(integer_list[[1]][[1]]),
  #         yes = integer_list[[1]][[1]],
  #       ))
  #   })

  for (i in 1:length(res$cid)) {
    for (j in 1:length(names_vec)) {

      res[i, j + 2] <- ifelse(
        test = !is.na(integer_list[[i]][[j]]),
        yes = integer_list[[i]][[j]],
        no = ifelse(
          test = !is.na(double_list[[i]][[j]]),
          yes = double_list[[i]][[j]],
          no = ifelse(
            test = !is.na(binary_list[[i]][[j]]),
            yes = binary_list[[i]][[j]],
            no = character_list[[i]][[j]]
          )
        )
      )

    }
  }

  colnames(res) <- c("CID", "Charge", names_vec)

  res <- transform(
    res,
    ExactMass = as.double(ExactMass),
    MolecularWeight = as.double(MolecularWeight),
    MonoIsotopicWeight = as.double(MonoIsotopicWeight),
    HeavyAtomCount = content$PC_Compounds$count$heavy_atom,
    AtomChiralCount = content$PC_Compounds$count$atom_chiral,
    AtomChiralDefCount = content$PC_Compounds$count$atom_chiral_def,
    AtomChiralUndefCount = content$PC_Compounds$count$atom_chiral_undef,
    BondChiralCount = content$PC_Compounds$count$bond_chiral,
    BondChiralDefCount = content$PC_Compounds$count$bond_chiral_def,
    BondChiralUndefCount = content$PC_Compounds$count$bond_chiral_undef,
    IsotopeAtomCount = content$PC_Compounds$count$isotope_atom,
    CovalentUnitCount = content$PC_Compounds$count$covalent_unit,
    TautomersCount = content$PC_Compounds$count$tautomers
  )

  res

}
