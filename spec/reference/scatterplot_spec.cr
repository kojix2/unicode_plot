require "../support/reference_helpers"

describe "Julia reference output compatibility - scatterplot" do
  x = [-1.0, 1.0, 3.0, 3.0, -1.0]
  y = [2.0, 0.0, -5.0, 2.0, -5.0]

describe "scatterplot" do
  it "matches scatterplot/default" do
    p = UnicodePlot.scatterplot(x, y)
    test_ref("scatterplot/default.txt", p)
  end

  it "matches scatterplot/y_only (1-based x-axis)" do
    p = UnicodePlot.scatterplot([2.0, 0.0, -5.0, 2.0, -5.0])
    test_ref("scatterplot/y_only.txt", p)
  end

  it "matches scatterplot/range1" do
    p = UnicodePlot.scatterplot((6..10).map(&.to_f).to_a)
    test_ref("scatterplot/range1.txt", p)
  end

  it "matches scatterplot/range2" do
    p = UnicodePlot.scatterplot((11..15).map(&.to_f).to_a, (6..10).map(&.to_f).to_a)
    test_ref("scatterplot/range2.txt", p)
  end

  it "matches scatterplot/scale1" do
    p = UnicodePlot.scatterplot(x.map { |v| v * 1e3 + 15 }, y.map { |v| v * 1e-3 - 15 })
    test_ref("scatterplot/scale1.txt", p)
  end

  it "matches scatterplot/scale2" do
    p = UnicodePlot.scatterplot(x.map { |v| v * 1e-3 + 15 }, y.map { |v| v * 1e3 - 15 })
    test_ref("scatterplot/scale2.txt", p)
  end

  it "matches scatterplot/scale3" do
    miny = -1.2796649117521434e218
    maxy = -miny
    p = UnicodePlot.scatterplot([1.0], [miny], xlim: {1.0, 1.0}, ylim: {miny, maxy})
    test_ref("scatterplot/scale3.txt", p)
  end

  it "matches scatterplot/limits" do
    p = UnicodePlot.scatterplot(x, y, xlim: {-1.5, 3.5}, ylim: {-5.5, 2.5})
    test_ref("scatterplot/limits.txt", p)
  end

  it "matches scatterplot/nogrid" do
    p = UnicodePlot.scatterplot(x, y, grid: false)
    test_ref("scatterplot/nogrid.txt", p)
  end

  it "matches scatterplot/blue" do
    p = UnicodePlot.scatterplot(x, y, color: :blue, name: "points1")
    test_ref("scatterplot/blue.txt", p)
  end

  it "matches scatterplot/parameters1" do
    p = UnicodePlot.scatterplot(x, y, name: "points1", title: "Scatter", xlabel: "x", ylabel: "y")
    test_ref("scatterplot/parameters1.txt", p)
  end

  it "matches scatterplot/parameters2" do
    p = UnicodePlot.scatterplot(x, y, name: "points1", title: "Scatter", xlabel: "x", ylabel: "y")
    UnicodePlot.scatterplot!(p, [0.5, 1.0, 1.5], name: "points2")
    test_ref("scatterplot/parameters2.txt", p)
  end

  it "matches scatterplot/parameters3" do
    p = UnicodePlot.scatterplot(x, y, name: "points1", title: "Scatter", xlabel: "x", ylabel: "y")
    UnicodePlot.scatterplot!(p, [0.5, 1.0, 1.5], name: "points2")
    UnicodePlot.scatterplot!(p, [-0.5, 0.5, 1.5], [0.5, 1.0, 1.5], name: "points3")
    test_ref("scatterplot/parameters3.txt", p)
  end

  it "matches scatterplot/nocolor" do
    p = UnicodePlot.scatterplot(x, y, name: "points1", title: "Scatter", xlabel: "x", ylabel: "y")
    UnicodePlot.scatterplot!(p, [0.5, 1.0, 1.5], name: "points2")
    UnicodePlot.scatterplot!(p, [-0.5, 0.5, 1.5], [0.5, 1.0, 1.5], name: "points3")
    test_ref("scatterplot/nocolor.txt", p)
  end

  it "matches scatterplot/canvassize" do
    p = UnicodePlot.scatterplot(x, y, title: "Scatter", canvas: :dot, height: 5, width: 10)
    test_ref("scatterplot/canvassize.txt", p)
  end

  it "matches scatterplot/units_temp" do
    y1 = UnicodePlot.quantity([22.0, 23.0, 24.0], "°C")
    p = UnicodePlot.scatterplot(y1, marker: :circle)
    y2 = UnicodePlot.quantity([23.5, 22.5, 23.0], "°C")
    UnicodePlot.scatterplot!(p, y2, marker: :cross, color: :red)
    test_ref("scatterplot/units_temp.txt", p)
  end
end

end
