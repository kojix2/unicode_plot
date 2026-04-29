require "../src/unicode_plot"

include UnicodePlot

# Sparse 5x18 matrix with both positive and negative values.
# auto-color mode: positive -> red ("> 0"), negative -> blue ("< 0")
a = Array.new(5) { Array.new(18, 0.0) }
a[0][3] = 1.0
a[3][6] = 2.0
a[2][17] = -5.0
a[4][8] = 3.0

p1 = spy(a, title: "Sparse pattern")
puts p1
puts

# Explicit color
p2 = spy(a, color: :green, title: "Green single color")
puts p2
puts

# xflip / yflip
p3 = spy(a, xflip: true, yflip: false, title: "Flipped axes")
puts p3
puts

# show_zeros: highlight zero entries instead of non-zeros
p4 = spy(a, show_zeros: true, title: "Zero entries")
puts p4
