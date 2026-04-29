# Fixtures for reference specs

This directory contains Julia-generated fixture data consumed by Crystal specs.
Fixtures are intended to be generated, not hand-edited.

## Quick regenerate

Run from repository root:

```bash
julia spec/fixtures/generate_julia_heatmap_data.jl
julia spec/fixtures/generate_julia_densityplot_data.jl
julia spec/fixtures/generate_julia_spy_data.jl
julia spec/fixtures/generate_julia_polarplot_data.jl
```

## Heatmap

- Data file: `julia_heatmap_data.json`
- Generator: `generate_julia_heatmap_data.jl`
- Purpose: keep heatmap input matrices aligned with UnicodePlots.jl reference inputs.
- Notes: deterministic output (seed `1337`).
- Consumer: `spec/reference_spec.cr`

## Densityplot

- Data file: `julia_densityplot_data.json`
- Generator: `generate_julia_densityplot_data.jl`
- Purpose: keep `x` and `y` samples aligned with UnicodePlots.jl densityplot tests.
- Notes: deterministic output (seed `1337`).
- Consumer: `spec/reference_spec.cr`

## Spy

- Data file: `julia_spy_data.json`
- Generator: `generate_julia_spy_data.jl`
- Purpose: keep sparse matrix fixtures aligned with UnicodePlots.jl spy tests.
- Notes: generated from stable sparse sampling logic in Julia.
- Consumer: `spec/reference_spec.cr`

## Polarplot

- Data file: `julia_polarplot_data.json`
- Generator: `generate_julia_polarplot_data.jl`
- Purpose: keep polarplot input parameters aligned with UnicodePlots.jl tests.
- Notes: stores deterministic linspace parameters (`start`, `stop`, `length`) for `theta` and `r`.
- Consumer: `spec/reference_spec.cr`
