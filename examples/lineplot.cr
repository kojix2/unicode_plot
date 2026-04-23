require "../src/unicode_plot"

include UnicodePlot

# Basic line plot
p = lineplot([1.0, 2.0, 3.0, 4.0, 5.0], [1.0, 4.0, 9.0, 16.0, 25.0],
  title: "Quadratic growth", xlabel: "input", ylabel: "response")
puts p
puts

# Sine wave
x = (0..62).map { |i| i * Math::PI / 31.0 }
y = x.map { |v| Math.sin(v) }
p = lineplot(x, y, title: "Periodic oscillation", xlabel: "phase", ylabel: "amplitude", color: :blue)
puts p
puts

# Multiple series with lineplot!
x = (1..20).map(&.to_f)
p = lineplot(x, x.map { |v| Math.sqrt(v) }, name: "root", color: :green,
  title: "Transform comparison", xlabel: "input")
lineplot!(p, x, x.map { |v| Math.log(v) }, name: "log", color: :red)
puts p
puts

# Plotting a function
p = lineplot(-3.0, 3.0, ->(t : Float64) { Math.exp(-t * t / 2.0) / Math.sqrt(2 * Math::PI) },
  title: "Bell-shaped kernel", xlabel: "input", ylabel: "density")
puts p
puts

# Log scale
x = (1..20).map(&.to_f)
p = lineplot(x, x.map { |v| v * v }, xscale: :log10, yscale: :log10,
  title: "Scaled power relation", xlabel: "input", ylabel: "response")
puts p
