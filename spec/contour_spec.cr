require "./spec_helper"

private def includes_point?(vertices : Array({Float64, Float64}), point : {Float64, Float64}, eps : Float64 = 1e-9) : Bool
  vertices.any? { |x, y| (x - point[0]).abs <= eps && (y - point[1]).abs <= eps }
end

describe UnicodePlot::Contour do
  it "generates contour levels inside finite extrema" do
    m = UnicodePlot::MatrixView.new([
      [0.0, 10.0],
    ])

    UnicodePlot::Contour.contour_levels(m, 4).should eq([2.0, 4.0, 6.0, 8.0])
  end

  it "rejects non-positive contour level counts" do
    expect_raises(ArgumentError, /positive/) do
      UnicodePlot::Contour.contour_levels(0.0, 1.0, 0)
    end
  end

  it "rejects mismatched matrix axes via contours" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0],
      [3.0, 4.0],
    ])

    expect_raises(ArgumentError, /x length/) do
      UnicodePlot::Contour.contours([1.0], [1.0, 2.0], m, 3)
    end
  end

  it "extracts a horizontal contour segment" do
    x = [0.0, 1.0]
    y = [0.0, 1.0]
    m = UnicodePlot::MatrixView.new([
      [0.0, 0.0],
      [1.0, 1.0],
    ])

    level = UnicodePlot::Contour.contour(x, y, m, 0.5)
    level.lines.size.should eq(1)
    vertices = level.lines.first.vertices
    includes_point?(vertices, {0.0, 0.5}).should be_true
    includes_point?(vertices, {1.0, 0.5}).should be_true
  end

  it "extracts a vertical contour segment" do
    x = [0.0, 1.0]
    y = [0.0, 1.0]
    m = UnicodePlot::MatrixView.new([
      [0.0, 1.0],
      [0.0, 1.0],
    ])

    level = UnicodePlot::Contour.contour(x, y, m, 0.5)
    level.lines.size.should eq(1)
    vertices = level.lines.first.vertices
    includes_point?(vertices, {0.5, 0.0}).should be_true
    includes_point?(vertices, {0.5, 1.0}).should be_true
  end

  it "handles ambiguous saddle case without crashing" do
    x = [0.0, 1.0]
    y = [0.0, 1.0]
    m = UnicodePlot::MatrixView.new([
      [0.0, 1.0],
      [1.0, 0.0],
    ])

    level = UnicodePlot::Contour.contour(x, y, m, 0.5)
    level.lines.size.should eq(2)
    level.lines.all? { |line| line.vertices.size >= 2 }.should be_true
  end

  it "skips cells with non-finite values" do
    x = [0.0, 1.0]
    y = [0.0, 1.0]
    m = UnicodePlot::MatrixView.new([
      [0.0, Float64::NAN],
      [1.0, 2.0],
    ])

    level = UnicodePlot::Contour.contour(x, y, m, 0.5)
    level.lines.should be_empty
  end
end

describe UnicodePlot do
  it "builds contourplot from z matrix" do
    p = UnicodePlot.contourplot([
      [0.0, 1.0, 2.0],
      [1.0, 2.0, 3.0],
      [2.0, 3.0, 4.0],
    ], levels: 3)

    p.should be_a(UnicodePlot::Plot)
  end

  it "builds contourplot from x y z" do
    x = [0.0, 1.0, 2.0]
    y = [0.0, 1.0, 2.0]
    z = [
      [0.0, 1.0, 2.0],
      [1.0, 2.0, 3.0],
      [2.0, 3.0, 4.0],
    ]

    p = UnicodePlot.contourplot(x, y, z, levels: [0.5, 1.5, 2.5])
    p.should be_a(UnicodePlot::Plot)
  end
end
