require "../src/unicode_plot"

include UnicodePlot

rng = Random.new(2_024_u64)

# Basic scatter plot
x = (1..20).map { |i| i.to_f + (rng.rand - 0.5) * 2 }
y = x.map { |v| 2.0 * v + 1.0 + (rng.rand - 0.5) * 4 }
p = scatterplot(x, y, title: "Correlated samples", xlabel: "axis_x", ylabel: "axis_y")
puts p
puts

# Scatter with custom marker
p = scatterplot(x, y, marker: :circle, color: :magenta,
  title: "Correlated samples with marker variation", xlabel: "axis_x", ylabel: "axis_y")
puts p
puts

# Two separated groups
x1 = (1..15).map { rng.rand * 3.0 + 1.0 }
y1 = (1..15).map { rng.rand * 3.0 + 1.0 }
x2 = (1..15).map { rng.rand * 3.0 + 6.0 }
y2 = (1..15).map { rng.rand * 3.0 + 6.0 }

p = scatterplot(x1, y1, name: "group_1", color: :blue,
  title: "Separated groups", xlabel: "axis_x", ylabel: "axis_y",
  xlim: {0.0, 11.0}, ylim: {0.0, 11.0})
scatterplot!(p, x2, y2, name: "group_2", color: :red)
puts p
