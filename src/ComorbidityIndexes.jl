module ComorbidityIndexes

using ICD10Utilities

export comorbiditylists

export flagcomorbidities
export scorecomorbidity

# comorbidity codes
include("quan.jl")
include("macss.jl")
include("comorbiditylists.jl")

# functions

"""
    flagcomorbidities(icdcodes, comorbidities)

Flag comorbidities in an array of ICD-10 codes.

`comorbidities` can be `:elixhauser` or `:charlson` for Quan ICD-10 versions of
Elixhauser and Charlson comorbidities, respectively, or `:macss` for the
Multipurpose Australian Comorbidity Scoring System.

Returns Dict giving true or false for each comorbidity.
"""
function flagcomorbidities(icdcodes, comorbidities)
  if !haskey(comorbiditylists, comorbidities)
    throw(DomainError(comorbidities, "Valid comorbidities are $(keys(comorbiditylists))"))
  elseif comorbidities in [:elixhauser, :charlson]
    return _quan(icdcodes, comorbiditylists[comorbidities])
  elseif comorbidities in [:macss]
    return _macss(icdcodes, comorbiditylists[comorbidities])
  end
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
  if haskey(RET, :severeliverdis) && RET[:severeliverdis]
    RET[:liverdisease] = false
  end
  if RET[:metastaticcancer]
    if haskey(RET, :malignancy)
      RET[:malignancy] = false
    elseif haskey(RET, :solidtumor)
      RET[:solidtumor] = false
    end
  end
  return RET
end

function _macss(icdcodes, comorbidities)
  RET = Dict{Symbol,Bool}()
  for cmrb in eachindex(comorbidities)
    RET[cmrb] = any(icd -> icd in comorbidities[cmrb], icdcodes)
  end
  return RET
end

"""
    scorecomorbidity(comorbidities, score)

Compute summary comorbidity score.

`comorbidities` should be the output from `flagcomorbidities`(@ref).
`score` should be `:charlson` for original Charlson weights, `:charlson_quan2011` for
Quan's updated Charlson weights, or `:vanwalraven` for the van Walraven weights
for the Elixhauser comorbidities.

It is your responsibility to request a score compatible with the comorbidity
flags you provide.
"""
function scorecomorbidity(comorbidities, score)
  if score == :charlson
    return comorbidities[:myocardialinfarction] +
           comorbidities[:congestiveheartfailure] +
           comorbidities[:periphvascdis] +
           comorbidities[:cerebrovascdis] +
           comorbidities[:dementia] +
           comorbidities[:chronicpulmonarydis] +
           comorbidities[:rheumaticdis] +
           comorbidities[:pepticulcerdis] +
           comorbidities[:mildliverdis] +
           comorbidities[:diabetes] +
           2 * (comorbidities[:diabetes_comp] +
            comorbidities[:paralysis] +
            comorbidities[:renaldis] +
            comorbidities[:malignancy]) +
           3 * comorbidities[:severeliverdis] +
           6 * (comorbidities[:metastaticcancer] + comorbidities[:hivaids])
  elseif score == :charlson_quan2011
    return comorbidities[:chronicpulmonarydis] +
           comorbidities[:rheumaticdis] +
           comorbidities[:diabetes_comp] +
           comorbidities[:renaldis] +
           2 * (comorbidities[:congestiveheartfailure] +
            comorbidities[:dementia] +
            comorbidities[:mildliverdis] +
            comorbidities[:paralysis] +
            comorbidities[:malignancy]) +
           4 * (comorbidities[:severeliverdis] + comorbidities[:hivaids]) +
           6 * comorbidities[:metastaticcancer]
  elseif score == :vanwalraven
    return -7 * (comorbidities[:drugabuse]) +
           -4 * (comorbidities[:obesity]) +
           -3 * (comorbidities[:depression]) +
           -2 * (comorbidities[:bloodlossanaemia] + comorbidities[:deficiencyanaemia]) +
           -1 * (comorbidities[:valvulardisease]) +
           2 * (comorbidities[:periphvascdis]) +
           3 * (comorbidities[:chronicpulmonarydis] + comorbidities[:coagulopathy]) +
           4 * (comorbidities[:pulmonarycircdisorders] + comorbidities[:solidtumor]) +
           5 * (comorbidities[:cardiacarrythmias] +
            comorbidities[:renalfailure] +
            comorbidities[:fluidelectrolytedisorders]) +
           6 * (comorbidities[:otherneurodisorders] + comorbidities[:weightloss]) +
           7 * (comorbidities[:congestiveheartfailure] + comorbidities[:paralysis]) +
           9 * (comorbidities[:lymphoma]) +
           11 * (comorbidities[:liverdisease]) +
           12 * (comorbidities[:metastaticcancer])
  end
end

end # module
