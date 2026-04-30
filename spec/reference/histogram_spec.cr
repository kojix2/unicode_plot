require "../support/reference_helpers"

describe "Julia reference output compatibility - histogram" do
  describe "histogram" do
    it "matches histogram/vert2 (deterministic vertical histogram)" do
      n = 30
      dat = [] of Float64
      (1..n).each { |i| i.times { dat << i.to_f } }
      p = UnicodePlot.histogram(dat, vertical: true, nbins: n)
      test_ref("histogram/vert2.txt", p)
    end

    it "matches histogram/float32" do
      p = UnicodePlot.histogram([0.1_f32, 0.1_f32, 0.0_f32])
      test_ref("histogram/float32.txt", p)
    end

    # The following cases reuse DENSITYPLOT_X which is identical to Julia's
    # `seed!(RNG, 1337); x = randn(RNG, 4000)` used in tst_histogram.jl.

    it "matches histogram/default" do
      p = UnicodePlot.histogram(DENSITYPLOT_X)
      test_ref("histogram/default.txt", p)
    end

    it "matches histogram/default_1e-2 (data scaled ×0.01)" do
      p = UnicodePlot.histogram(DENSITYPLOT_X.map { |v| v * 0.01 })
      test_ref("histogram/default_1e-2.txt", p)
    end

    it "matches histogram/default_1e2 (data scaled ×100)" do
      p = UnicodePlot.histogram(DENSITYPLOT_X.map { |v| v * 100.0 })
      test_ref("histogram/default_1e2.txt", p)
    end

    it "matches histogram/log10 (xscale: :log10)" do
      p = UnicodePlot.histogram(DENSITYPLOT_X, xscale: :log10)
      test_ref("histogram/log10.txt", p)
    end

    it "matches histogram/log10_label (xscale: :log10 with custom xlabel)" do
      p = UnicodePlot.histogram(DENSITYPLOT_X, xlabel: "custom label", xscale: :log10)
      test_ref("histogram/log10_label.txt", p)
    end

    it "matches histogram/parameters1 (title, xlabel, color:blue, margin, padding)" do
      p = UnicodePlot.histogram(
        DENSITYPLOT_X,
        title: "My Histogram",
        xlabel: "Absolute Frequency",
        color: :blue,
        margin: 7,
        padding: 3,
      )
      test_ref("histogram/parameters1.txt", p)
    end

    it "matches histogram/parameters2 (title, color:yellow, border:solid, symbols:[=], width:50)" do
      p = UnicodePlot.histogram(
        DENSITYPLOT_X,
        title: "My Histogram",
        xlabel: "Absolute Frequency",
        color: :yellow,
        border: :solid,
        symbols: ['='],
        width: 50,
      )
      test_ref("histogram/parameters2.txt", p)
    end
  end
end
