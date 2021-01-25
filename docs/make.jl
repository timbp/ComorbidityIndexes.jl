using Documenter, ComorbidityIndexes

makedocs(
	 sitename = "Comorbidity Indexes",
   modules=[ComorbidityIndexes],
      format = Documenter.HTML(
        canonical = "https://timbp.github.io/ComorbidityIndexes.jl/stable/",
        edit_link = "main",
    ),
)

deploydocs(
    repo = "github.com/timbp/ComorbidityIndexes.jl.git",
    devbranch = "main",
)
