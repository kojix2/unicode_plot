require "../src/unicode_plot"

include UnicodePlot

# Basic contour plot
x = (-20..20).map { |i| i.to_f64 / 10.0 }
y = (-20..20).map { |i| i.to_f64 / 10.0 }
z = y.map do |yv|
  x.map do |xv|
    # Saddle-like field
    xv * xv - yv * yv
  end
end

p = contourplot(
  x,
  y,
  z,
  levels: 8,
  title: "Contour: x^2 - y^2",
  xlabel: "x",
  ylabel: "y"
)
puts p
puts

# Overlay with contourplot!
z2 = y.map do |yv|
  x.map do |xv|
    # Shifted Gaussian bump
    Math.exp(-((xv - 0.7) ** 2 + (yv + 0.4) ** 2) / 0.25)
  end
end

p2 = contourplot(
  x,
  y,
  z,
  levels: 8,
  title: "Contour overlay: saddle + bump",
  xlabel: "x",
  ylabel: "y"
)
contourplot!(p2, x, y, z2, levels: 4, colormap: :magma)
puts p2
