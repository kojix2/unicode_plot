require "../src/unicode_plot"

include UnicodePlot

rng = Random.new(512_u64)

# Single series
data = [2.0, 5.0, 7.0, 8.0, 3.0, 6.0, 9.0, 1.0, 4.0, 10.0, 11.0, 0.5]
p1 = boxplot(data, title: "Single distribution", name: "profile_1")
puts p1
puts

# Multiple series
d1 = Array.new(50) { rng.rand * 10.0 }
d2 = Array.new(50) { rng.rand * 10.0 + 2.0 }
d3 = Array.new(50) { rng.rand * 5.0 + 5.0 }
p2 = boxplot([d1, d2, d3], names: ["profile_1", "profile_2", "profile_3"], title: "Profile comparison")
puts p2
puts

# Hash syntax
p3 = boxplot({"segment_1" => [1.0, 2.0, 3.0, 4.0, 5.0, 10.0],
              "segment_2" => [3.0, 4.0, 5.0, 6.0, 7.0, -1.0]},
  title: "Segment summary")
puts p3
puts

# boxplot! incremental
p4 = boxplot([1.0, 2.0, 3.0, 4.0, 5.0], name: "profile_1")
boxplot!(p4, [3.0, 4.0, 5.0, 6.0, 7.0], name: "profile_2")
puts p4
