include("../quan.jl")
include("../macss.jl")

const comorbiditylists = Dict{Symbol, NamedTuple}(
  :elixhauser => ElixICD10,
  :charlson => CharlsonICD10,
  :macss => MACSS
)
