module ComorbidityIndexes

using ICD10Utilities

export QuanElixICD10
export QuanCCIICD10
export flagcomorbidities

# comorbidity codes
include("quan.jl")

# functions

"""
    flagcomorbidities(icdcodes, comorbidities=QuanElixICD10)

Flag comorbidities in an array of ICD-10 codes.

`comorbidities` can be `QuanElixICD10` or `QuanCCIICD10` for Quan versions of
Elixhauser and Charlson comorbidities, respectively.

Returns NamedTuple giving true or false for each comorbidity.

Weights, summed score, not provided.
"""
function flagcomorbidities(icdcodes, comorbidities=QuanElixICD10)
  RET = falses(lastindex(comorbidities))
  i = 1
  for cmrb in comorbidities
    RET[i] = any(icd -> icd3(icd) in icd3.(cmrb[1]), icdcodes) || any(icd -> icd4(icd) in icd4.(cmrb[2]), icdcodes)
    i += 1
  end
  return (; zip(eachindex(comorbidities), RET)...)
end

end # module
