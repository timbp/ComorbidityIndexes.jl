# ComorbidityIndexes.jl

This package implements several comorbidity indexes in ICD-10 coding.

Currently available are the Charlson and Elixhauser comorbidities, using the
Quan (2005) ICD-10 codes, and the Multipurpose Australian Comorbidity Scoring
System (MACSS) using ICD-10-AM codes.

Summary scores for the Charlson comorbidity index can be calculated using the original Charlson
weights or the updated Quan (2011) weights. A summary score for the Elixhauser
comorbidities can be calculated using the van Walraven (2009) weights.

```@autodocs
Modules = [ComorbidityIndexes]

```
