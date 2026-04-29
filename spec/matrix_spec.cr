require "./spec_helper"

describe UnicodePlot::MatrixView do
  it "stores rectangular matrix dimensions" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ])

    m.nrows.should eq(2)
    m.ncols.should eq(3)
    m[0, 1].should eq(2.0)
    m[1, 2].should eq(6.0)
  end

  it "rejects jagged matrices" do
    expect_raises(ArgumentError, /same length/) do
      UnicodePlot::MatrixView.new([
        [1.0, 2.0],
        [3.0],
      ])
    end
  end

  it "allows empty matrices at the view level" do
    m = UnicodePlot::MatrixView.new([] of Array(Float64))

    m.nrows.should eq(0)
    m.ncols.should eq(0)
    m.empty?.should be_true
  end
end

describe ".matrix_axis_coords" do
  it "uses one-based coordinates when fact is nil" do
    UnicodePlot.matrix_axis_coords(3, nil, 0.0).should eq([1.0, 2.0, 3.0])
  end

  it "applies offset to one-based coordinates when fact is nil" do
    UnicodePlot.matrix_axis_coords(3, nil, 10.0).should eq([11.0, 12.0, 13.0])
  end

  it "uses zero-based scaled coordinates when fact is given" do
    UnicodePlot.matrix_axis_coords(3, 0.5, 10.0).should eq([10.0, 10.5, 11.0])
  end
end

describe ".matrix_extrema_finite" do
  it "returns min and max of finite values" do
    m = UnicodePlot::MatrixView.new([
      [1.0, Float64::NAN],
      [3.0, -2.0],
    ])

    UnicodePlot.matrix_extrema_finite(m).should eq({-2.0, 3.0})
  end

  it "ignores infinities" do
    m = UnicodePlot::MatrixView.new([
      [Float64::INFINITY, 2.0],
      [-Float64::INFINITY, 5.0],
    ])

    UnicodePlot.matrix_extrema_finite(m).should eq({2.0, 5.0})
  end

  it "returns nil when there are no finite values" do
    m = UnicodePlot::MatrixView.new([
      [Float64::NAN, Float64::INFINITY],
    ])

    UnicodePlot.matrix_extrema_finite(m).should be_nil
  end
end
