require "../src/unicode_plot"

include UnicodePlot

# 2D point-density plot using the two-array API
# Approximate a diffuse field using the sum-of-uniforms trick
rng = Random.new(1_337_u64)
n = 1000
xs = Array.new(n) { (Array.new(12) { rng.next_float }.sum - 6.0) }
ys = Array.new(n) { (Array.new(12) { rng.next_float }.sum - 6.0) }

p1 = densityplot(xs, ys, title: "Diffuse field", xlabel: "axis_x", ylabel: "axis_y")
puts p1
puts

# Two separated fields overlaid with densityplot!
xs2 = Array.new(500) { (Array.new(12) { rng.next_float }.sum - 6.0) }
ys2 = Array.new(500) { (Array.new(12) { rng.next_float }.sum - 6.0) }
xs3 = Array.new(500) { (Array.new(12) { rng.next_float }.sum - 6.0) + 4.0 }
ys3 = Array.new(500) { (Array.new(12) { rng.next_float }.sum - 6.0) + 4.0 }

p2 = densityplot(xs2, ys2, name: "field_1", title: "Offset fields")
densityplot!(p2, xs3, ys3, name: "field_2")
puts p2
