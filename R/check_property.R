.check_property <- function(property) {

  if (is.na(property) || is.null(property)) {
    FALSE
  } else if (!(tolower(property) %in%
               tolower(
                 c(
                   "MolecularFormula",
                   "MolecularWeight",
                   "CanonicalSMILES",
                   "IsomericSMILES",
                   "InChI",
                   "InChIKey",
                   "IUPACName",
                   "Title",
                   "XLogP",
                   "ExactMass",
                   "MonoisotopicMass",
                   "TPSA",
                   "Complexity",
                   "Charge",
                   "HBondDonorCount",
                   "HBondAcceptorCount",
                   "RotatableBondCount",
                   "HeavyAtomCount",
                   "IsotopeAtomCount",
                   "AtomStereoCount",
                   "DefinedAtomStereoCount",
                   "UndefinedAtomStereoCount",
                   "BondStereoCount",
                   "DefinedBondStereoCount",
                   "UndefinedBondStereoCount",
                   "CovalentUnitCount",
                   "Volume3D",
                   "XStericQuadrupole3D",
                   "YStericQuadrupole3D",
                   "ZStericQuadrupole3D",
                   "FeatureCount3D",
                   "FeatureAcceptorCount3D",
                   "FeatureDonorCount3D",
                   "FeatureAnionCount3D",
                   "FeatureCationCount3D",
                   "FeatureRingCount3D",
                   "FeatureHydrophobeCount3D",
                   "ConformerModelRMSD3D",
                   "EffectiveRotorCount3D",
                   "ConformerCount3D",
                   "Fingerprint2D",
                   "all"
                  )
                )
              )
            ) {
    FALSE
  } else {
    TRUE
  }

}
