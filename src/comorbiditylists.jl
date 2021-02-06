include("quan.jl")
include("macss.jl")

const comorbiditylists = Dict{Symbol, NamedTuple}(
  :quan_elixhauser => QuanElixICD10,
  :quan_charlson => QuanCCIICD10,
  :macss => MACSS
)
