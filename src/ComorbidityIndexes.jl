module ComorbidityIndexes

using ICD10Utilities

export QuanElixICD10
export QuanCCIICD10
export flagcomorbidities

# comorbidity codes
include("quan.jl")

# functions

"""
    flagcomorbidities(icdcodes, comorbidities)

Flag comorbidities in an array of ICD-10 codes.

`comorbidities` can be `QuanElixICD10` or `QuanCCIICD10` for Quan versions of
Elixhauser and Charlson comorbidities, respectively.

Returns NamedTuple giving true or false for each comorbidity.

Weights, summed score, not provided.
"""
function flagcomorbidities(icdcodes, comorbidities)
  return _quan(icdcodes, CMRB[comorbidities])
end

function _quan(icdcodes, comorbidities)
  RET = Dict{Symbol,Bool}()
  for cmrb in eachindex(comorbidities)
    RET[cmrb] = any(icd -> icd3(icd) in icd3.(comorbidities[cmrb][1]), icdcodes) ||
                any(icd -> icd4(icd) in icd4.(comorbidities[cmrb][2]), icdcodes)
  end
  if RET[:diabetes_comp]
    RET[:diabetes] = false
  end
  if RET[:severeliverdis]
    RET[:liverdisease] = false
  end
  if RET[:metastaticcancer]
    RET[:malignancy] = false
  end
  return RET
end

end # module
