require "./spec_helper"

describe UnicodePlot::MatrixView do
  it "stores rectangular matrix dimensions" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ])

    m.nrows.should eq(2)
    m.ncols.should eq(3)
    m.shape.should eq({2, 3})
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

describe ".validate_matrix_axes!" do
  it "accepts matching matrix axes" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0],
      [3.0, 4.0],
    ])

    UnicodePlot.validate_matrix_axes!(m, [1.0, 2.0], [1.0, 2.0])
  end

  it "rejects mismatched x axis length" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0],
      [3.0, 4.0],
    ])

    expect_raises(ArgumentError, /x length/) do
      UnicodePlot.validate_matrix_axes!(m, [1.0], [1.0, 2.0])
    end
  end

  it "rejects mismatched y axis length" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0],
      [3.0, 4.0],
    ])

    expect_raises(ArgumentError, /y length/) do
      UnicodePlot.validate_matrix_axes!(m, [1.0, 2.0], [1.0])
    end
  end
end

describe "matrix coordinate helpers" do
  it "returns column coordinates" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ])

    UnicodePlot.matrix_col_coords(m).should eq([1.0, 2.0, 3.0])
  end

  it "returns row coordinates" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ])

    UnicodePlot.matrix_row_coords(m).should eq([1.0, 2.0])
  end

  it "returns reversed row coordinates" do
    m = UnicodePlot::MatrixView.new([
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
    ])

    UnicodePlot.matrix_reversed_row_coords(m).should eq([2.0, 1.0])
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
