require "../src/unicode_plot"

include UnicodePlot

# Box-Muller transform for centered samples
def normal_sample(rng : Random, mean : Float64 = 0.0, std : Float64 = 1.0) : Float64
  u1 = rng.rand
  u2 = rng.rand
  z = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math::PI * u2)
  mean + std * z
end

# Centered sample set
rng = Random.new(42_u64)
normal = (1..5000).map { normal_sample(rng) }

p = histogram(normal, title: "Centered samples", xlabel: "value")
puts p
puts

# Specify bin count
p = histogram(normal, nbins: 20, color: :blue,
  title: "Centered samples with fixed bins")
puts p
puts

# Bounded sample set
rng_uniform = Random.new(84_u64)
uniform = (1..300).map { rng_uniform.rand * 10.0 }
p = histogram(uniform, title: "Bounded samples")
puts p
puts

# Vertical histogram
p = histogram(normal, nbins: 15, vertical: true,
  title: "Vertical sample counts", ylabel: "count")
puts p
