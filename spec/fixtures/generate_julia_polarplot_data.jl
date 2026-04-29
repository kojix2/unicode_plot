# Generates deterministic polarplot fixtures matching UnicodePlots.jl test inputs.
# This stores linspace parameters so Crystal specs can reconstruct exact arrays.

function write_json(path::String)
    open(path, "w") do io
        write(io, "{\n")
        write(io, "  \"simple\": {\n")
        write(io, "    \"theta\": {\"start\": 0.0, \"stop\": $(repr(2pi)), \"length\": 20},\n")
        write(io, "    \"r\": {\"start\": 0.0, \"stop\": 2.0, \"length\": 20}\n")
        write(io, "  },\n")
        write(io, "  \"simple_with_rlim\": {\n")
        write(io, "    \"theta\": {\"start\": 0.0, \"stop\": $(repr(2pi)), \"length\": 20},\n")
        write(io, "    \"r\": {\"start\": 0.0, \"stop\": 2.0, \"length\": 20},\n")
        write(io, "    \"rlim\": [0.0, 3.0]\n")
        write(io, "  },\n")
        write(io, "  \"callable\": {\n")
        write(io, "    \"theta\": {\"start\": 0.0, \"stop\": $(repr(4pi)), \"length\": 40}\n")
        write(io, "  },\n")
        write(io, "  \"kwargs\": {\n")
        write(io, "    \"theta\": {\"start\": 0.0, \"stop\": $(repr(2pi)), \"length\": 20},\n")
        write(io, "    \"r\": {\"start\": 0.0, \"stop\": 1.0, \"length\": 20},\n")
        write(io, "    \"size_scale\": 1.5\n")
        write(io, "  }\n")
        write(io, "}\n")
    end
end

out = joinpath(@__DIR__, "julia_polarplot_data.json")
write_json(out)
println("Written: $out")
