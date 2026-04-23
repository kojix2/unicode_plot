require "../src/unicode_plot"

include UnicodePlot

# Basic bar plot
levels = ["layer_1", "layer_2", "layer_3", "layer_4", "layer_5"]
weights = [13.96, 16.79, 24.18, 12.33, 9.21]

p = barplot(levels, weights,
  title: "Relative weights", xlabel: "weight")
puts p
puts

# From a Hash (sorted by key automatically)
data = {"axis_a" => 95.0, "axis_b" => 98.0, "axis_c" => 72.0, "axis_d" => 68.0, "axis_e" => 85.0}
p = barplot(data, title: "Axis scores", xlabel: "score", color: :cyan)
puts p
puts

# Gradient bar symbols (sub-character resolution)
bands = ["band_1", "band_2", "band_3", "band_4", "band_5"]
vals = [100.0, 88.5, 75.2, 92.1, 89.4]
p = barplot(bands, vals,
  title: "Resolution bands",
  symbols: [' ', '▏', '▎', '▍', '▌', '▋', '▊', '▉', '█'],
  color: :green)
puts p
puts

# Adding bars to an existing plot with barplot!
p = barplot(["stage_1"], [42.0], title: "Incremental stages")
barplot!(p, "stage_2", 67.0)
barplot!(p, "stage_3", 31.0, color: :yellow)
puts p
