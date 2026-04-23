require "./spec_helper"
include UnicodePlot

describe "quick checks" do
  it "computes the expected narrow plotting range for scale3" do
    plotting_range_narrow(-1.0, 700_000.0).should eq({-100_000.0, 700_000.0})
  end

  it "formats scale3 labels with thousands separators" do
    nice_repr(700_000).should eq("700 000")
    nice_repr(-100_000).should eq("-100 000")
  end

  it "renders the scale3 plot without writing debug output" do
    p = UnicodePlot.lineplot([-1.0, 2.0, 3.0, 700_000.0], [1.0, 2.0, 9.0, 4_000_000.0])
    s = p.to_s
    s.should contain("700 000")
    s.should contain("4 000 000")
  end
end
