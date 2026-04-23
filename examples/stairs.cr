require "../src/unicode_plot"

include UnicodePlot

x = [1.0, 2.0, 3.0, 4.0, 5.0]
y = [1.0, 3.0, 2.0, 4.0, 3.0]

p1 = stairs(x, y, title: "Post-step profile", name: "profile_1")
puts p1
puts

p2 = stairs(x, y, title: "Pre-step profile", style: :pre, name: "profile_1", color: :red)
puts p2
puts

# Two series
p3 = stairs(x, y, title: "Layered step profiles")
stairs!(p3, x, y.map { |v| v * 0.5 }, name: "profile_2", style: :pre)
puts p3
