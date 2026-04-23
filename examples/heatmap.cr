require "../src/unicode_plot"

include UnicodePlot

# Simple 2D function z = sin(x) * cos(y)
n = 20
z = (0...n).map do |i|
  (0...n).map do |j|
    x = -Math::PI + 2.0 * Math::PI * i / (n - 1)
    y = -Math::PI + 2.0 * Math::PI * j / (n - 1)
    Math.sin(x) * Math.cos(y)
  end
end
p1 = heatmap(z, title: "sin(x)*cos(y)", colormap: :viridis)
puts p1
puts

# Plasma colormap
p2 = heatmap(z, title: "Wave surface", colormap: :plasma)
puts p2
puts

# Gray colormap
p3 = heatmap(z, title: "Wave surface in gray", colormap: :gray)
puts p3
