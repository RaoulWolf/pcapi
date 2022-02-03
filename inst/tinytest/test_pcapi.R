
# .check_cid()
expect_false(pcapi:::.check_cid(NA))

expect_false(pcapi:::.check_cid(NULL))

expect_false(pcapi:::.check_cid(TRUE))

expect_false(pcapi:::.check_cid(-1L))

expect_true(pcapi:::.check_cid(1L))

# .check_format()
expect_false(pcapi:::.check_format(NULL))

expect_false(pcapi:::.check_format("formula"))

expect_true(pcapi:::.check_format("inchi"))

# .check_inchi()
expect_false(pcapi:::.check_inchi(NA))

expect_false(pcapi:::.check_inchi(NULL))

expect_false(pcapi:::.check_inchi("0123456789"))

expect_false(pcapi:::.check_inchi("1S/C2H6O/c1-2-3/h3H,2H2,1H3"))

expect_true(pcapi:::.check_inchi("InChI=1S/C2H6O/c1-2-3/h3H,2H2,1H3"))

# .check_inchikey()
expect_false(pcapi:::.check_inchikey(NA))

expect_false(pcapi:::.check_inchikey(NULL))

expect_false(pcapi:::.check_inchikey("lfqscwfljhtthz-uhfffaoysa-n"))

expect_false(pcapi:::.check_inchikey("LFQSCWFLJHTTHZ-UHFFFAOYSA-NN"))

expect_false(pcapi:::.check_inchikey("LFQSCWFLJHTTHZ-UHFFF-OYSA-N"))

expect_false(pcapi:::.check_inchikey("LFQSCWFLJHTTHZU-HFFFAOYSA-N"))

expect_false(pcapi:::.check_inchikey("LFQSCWFLJHTTHZ-UHFFFAOYS-AN"))

expect_true(pcapi:::.check_inchikey("LFQSCWFLJHTTHZ-UHFFFAOYSA-N"))

# .check_json()
expect_false(pcapi:::.check_json(NA))

expect_false(pcapi:::.check_json(NULL))

expect_false(pcapi:::.check_json(1))

expect_true(pcapi:::.check_json(TRUE))

# .check_property()
expect_false(pcapi:::.check_property(NA))

expect_false(pcapi:::.check_property(NULL))

expect_false(pcapi:::.check_property("inchi"))

expect_true(pcapi:::.check_property("all"))

# .check_smiles()
expect_false(pcapi:::.check_smiles(NA))

expect_false(pcapi:::.check_smiles(NULL))

expect_false(pcapi:::.check_smiles("0123456789"))

expect_true(pcapi:::.check_smiles("CCO"))

# post_to_cid()
expect_error(
  post_to_cid("C2H6O", format = "formula")
)

expect_error(
  post_to_cid("LFQSCWFLJHTTHZ-UHFFFAOYSA-N", format = "inchi")
)

expect_error(
  post_to_cid("InChI=1S/C2H6O/c1-2-3/h3H,2H2,1H3", format = "inchikey")
)

expect_error(
  post_to_cid("26", format = "smiles")
)

expect_error(
  post_to_cid("CCO", format = "smiles", json = "no")
)

expect_equal(
  post_to_cid("CCO", format = "smiles"),
  702L
)

# post_to_property()
expect_error(
  post_to_property(cid = "One")
)

expect_error(
  post_to_property(cid = 702, property = "Smell")
)

expect_error(
  post_to_property(cid = 702, json = "yes")
)

expect_equal(
  dim(post_to_property(cid = c(702, 887))),
  c(2L, 42L)
)
