using Random: seed!, randsubseq
using SparseArrays
using StableRNGs

# Mirrors UnicodePlots.jl test/fixes.jl _stable_sprand.
# sprand is not stable across Julia versions; this implementation is.
function _stable_sprand(rng, m::Integer, n::Integer, density::AbstractFloat)
    I = Int[]
    J = Int[]
    for li in randsubseq(rng, 1:(m * n), density)
        j, i = divrem(li - 1, m)
        push!(I, i + 1)
        push!(J, j + 1)
    end
    V = rand(rng, length(I))
    return sparse(I, J, V)
end

function sparse_to_dict(A::SparseMatrixCSC)
    rows_i, cols_j, vals_v = findnz(A)
    Dict(
        "nrows" => size(A, 1),
        "ncols" => size(A, 2),
        "rows"  => rows_i,
        "cols"  => cols_j,
        "vals"  => vals_v,
    )
end

function write_json_value(io::IO, v)
    if v isa AbstractVector{Int}
        print(io, "[")
        for (k, x) in enumerate(v)
            k > 1 && print(io, ",")
            print(io, x)
        end
        print(io, "]")
    elseif v isa AbstractVector{Float64}
        print(io, "[")
        for (k, x) in enumerate(v)
            k > 1 && print(io, ",")
            print(io, repr(x))
        end
        print(io, "]")
    elseif v isa Integer
        print(io, v)
    else
        error("unhandled type: $(typeof(v))")
    end
end

function write_spy_json(path::String, cases::Vector{Pair{String,SparseMatrixCSC}})
    open(path, "w") do io
        println(io, "{")
        for (k, (name, A)) in enumerate(cases)
            d = sparse_to_dict(A)
            print(io, "  ", repr(name), ": {")
            fields = ["nrows", "ncols", "rows", "cols", "vals"]
            for (fi, f) in enumerate(fields)
                print(io, repr(f), ": ")
                write_json_value(io, d[f])
                fi < length(fields) && print(io, ", ")
            end
            print(io, "}")
            k < length(cases) ? println(io, ",") : println(io)
        end
        println(io, "}")
    end
end

function main()
    rng = StableRNG(1_337)

    cases = Pair{String,SparseMatrixCSC}[]

    seed!(rng, 1_337); push!(cases, "10x10"  => _stable_sprand(rng, 10,    10,   0.15))
    seed!(rng, 1_337); push!(cases, "10x15"  => _stable_sprand(rng, 10,    15,   0.15))
    seed!(rng, 1_337); push!(cases, "15x10"  => _stable_sprand(rng, 15,    10,   0.15))
    seed!(rng, 1_337); push!(cases, "200x200_normal" => _stable_sprand(rng, 200, 200, 0.001))
    seed!(rng, 1_337); push!(cases, "200x200_zeros"  => _stable_sprand(rng, 200, 200, 0.99))
    seed!(rng, 1_337); push!(cases, "80x80"   => _stable_sprand(rng, 80,    80,   0.15))
    seed!(rng, 1_337); push!(cases, "2000x200" => _stable_sprand(rng, 2000, 200, 0.0001))
    seed!(rng, 1_337); push!(cases, "200x2000" => _stable_sprand(rng, 200, 2000, 0.0001))

    out = joinpath(dirname(@__FILE__), "julia_spy_data.json")
    write_spy_json(out, cases)
    println("Written: $out")
end

main()
