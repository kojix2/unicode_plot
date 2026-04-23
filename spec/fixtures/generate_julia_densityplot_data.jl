using Random: seed!
using StableRNGs

# Generates the exact x/y input used by UnicodePlots.jl test/tst_densityplot.jl.
rng = StableRNG(1337)
seed!(rng, 1337)
x = randn(rng, 4000)
y = randn(rng, 4000)

function arr_json(arr, base_indent = "  ")
  item_indent = base_indent * "  "
  "[\n" * item_indent * join(string.(arr), ",\n" * item_indent) * "\n" * base_indent * "]"
end

open(joinpath(@__DIR__, "julia_densityplot_data.json"), "w") do io
  write(io, "{\n")
  write(io, "  \"x\": ")
  write(io, arr_json(x, "  "))
  write(io, ",\n")
  write(io, "  \"y\": ")
  write(io, arr_json(y, "  "))
  write(io, "\n}\n")
end
