require "../src/unicode_plot"

include UnicodePlot

# Basic spiral-like polar line
theta = (0...40).map { |i| 4.0 * Math::PI * i.to_f64 / 39.0 }
r = theta.map { |angle| angle / (2.0 * Math::PI) }

p1 = polarplot(theta, r, title: "Polar line", color: :green)
puts p1
puts

# Polar scatter mode (lines: false)
theta2 = (0...20).map { |i| 2.0 * Math::PI * i.to_f64 / 19.0 }
r2 = (0...20).map { |i| 1.0 + 0.2 * Math.sin(i.to_f64) }

p2 = polarplot(theta2, r2,
  lines: false,
  color: :red,
  marker: :circle,
  border: :solid,
  title: "Polar scatter")
puts p2
puts

# Explicit radial limit and callable radius
theta3 = (0...50).map { |i| 3.0 * Math::PI * i.to_f64 / 49.0 }
p3 = polarplot(theta3,
  ->(angle : Float64) { 1.0 + 0.5 * Math.cos(3.0 * angle) },
  rlim: {0.0, 2.0},
  title: "Callable radius with rlim")
puts p3
