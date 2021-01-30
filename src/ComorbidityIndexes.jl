module ComorbidityIndexes

using ICD10Utilities

export QuanElixICD10
export flagcomorbidities

# comorbidity codes
include("quan.jl")

# functions
function flagcomorbidities(A, comorbidity=:quan_elixhauser)
  if comorbidity == :quan_elixhauser
    return quanelixhauser(A, QuanElixICD10)
  elseif comorbidity == :quan_charlson
  end
end

function quanelixhauser(icdcodes, comorbcodes)
  RET = falses(lastindex(comorbcodes))
  i = 1
  for cmrb in comorbcodes
    RET[i] = any(icd -> icd4(icd) in icd4.(cmrb), icdcodes)
    i += 1
  end
  return eachindex(comorbcodes) .=> RET
end

end # module
