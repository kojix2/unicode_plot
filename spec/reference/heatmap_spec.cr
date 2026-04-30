require "../support/reference_helpers"

describe "Julia reference output compatibility - heatmap" do
  describe "heatmap" do
    it "matches heatmap/default_0x0" do
      z = Array(Array(Float64)).new(0) { Array(Float64).new(0, 0.0) }
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_0x0.txt", p)
    end

    it "matches heatmap/default_5x0" do
      z = Array.new(5) { [] of Float64 }
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_5x0.txt", p)
    end

    it "matches heatmap/default_10x0" do
      z = Array.new(10) { [] of Float64 }
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_10x0.txt", p)
    end

    # integers_20x20: repeat(collect(1:20), outer=(1,20)) → A[i,j] = i
    it "matches heatmap/integers_20x20" do
      z = Array.new(20) { |i| Array.new(20) { |_j| (i + 1).to_f } }
      p = UnicodePlot.heatmap(z)
      test_ref("heatmap/integers_20x20.txt", p)
    end

    # zeros_20x20: all zeros
    it "matches heatmap/zeros_20x20" do
      z = Array.new(20) { Array.new(20, 0.0) }
      p = UnicodePlot.heatmap(z)
      test_ref("heatmap/zeros_20x20.txt", p)
    end

    # sizing defaults from Julia tst_heatmap.jl (labels=false)
    it "matches heatmap/default_1x1" do
      z = heatmap_fixture_matrix("1x1")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_1x1.txt", p)
    end

    it "matches heatmap/default_1x2" do
      z = heatmap_fixture_matrix("1x2")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_1x2.txt", p)
    end

    it "matches heatmap/default_2x1" do
      z = heatmap_fixture_matrix("2x1")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_2x1.txt", p)
    end

    it "matches heatmap/default_10x10" do
      z = heatmap_fixture_matrix("10x10")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_10x10.txt", p)
    end

    it "matches heatmap/default_10x15" do
      z = heatmap_fixture_matrix("10x15")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_10x15.txt", p)
    end

    it "matches heatmap/default_15x10" do
      z = heatmap_fixture_matrix("15x10")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_15x10.txt", p)
    end

    it "matches heatmap/default_20x200" do
      z = heatmap_fixture_matrix("20x200")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_20x200.txt", p)
    end

    it "matches heatmap/default_200x20" do
      z = heatmap_fixture_matrix("200x20")
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/default_200x20.txt", p)
    end

    # fix_aspect_ratio_30x30: outer product 1:30 × 1:30, fix_ar=true
    it "matches heatmap/fix_aspect_ratio_30x30" do
      z = Array.new(30) { |i| Array.new(30) { |j| (i + 1).to_f * (j + 1).to_f } }
      p = UnicodePlot.heatmap(z, fix_ar: true)
      test_ref("heatmap/fix_aspect_ratio_30x30.txt", p)
    end

    # array_convention: outer product 1:20 × 1:20, array=true, fix_ar=true
    it "matches heatmap/array_convention" do
      z = Array.new(20) { |i| Array.new(20) { |j| (i + 1).to_f * (j + 1).to_f } }
      p = UnicodePlot.heatmap(z, array: true, fix_ar: true)
      test_ref("heatmap/array_convention.txt", p)
    end

    # scaling_11x11_xfact_0.1: repeat(collect(0:10), outer=(1,11)) → A[i,j] = i-1; xfact=0.1
    it "matches heatmap/scaling_11x11_xfact_0.1" do
      z = Array.new(11) { |i| Array.new(11) { |_j| i.to_f } }
      p = UnicodePlot.heatmap(z, xfact: 0.1)
      test_ref("heatmap/scaling_11x11_xfact_0.1.txt", p)
    end

    # scaling_11x11_yfact_0.1
    it "matches heatmap/scaling_11x11_yfact_0.1" do
      z = Array.new(11) { |i| Array.new(11) { |_j| i.to_f } }
      p = UnicodePlot.heatmap(z, yfact: 0.1)
      test_ref("heatmap/scaling_11x11_yfact_0.1.txt", p)
    end

    # scaling_11x11_xfact_0.1_xoffset_-0.5
    it "matches heatmap/scaling_11x11_xfact_0.1_xoffset_-0.5" do
      z = Array.new(11) { |i| Array.new(11) { |_j| i.to_f } }
      p = UnicodePlot.heatmap(z, xfact: 0.1, xoffset: -0.5)
      test_ref("heatmap/scaling_11x11_xfact_0.1_xoffset_-0.5.txt", p)
    end

    # scaling_11x11_yfact_0.1_yoffset_-0.5
    it "matches heatmap/scaling_11x11_yfact_0.1_yoffset_-0.5" do
      z = Array.new(11) { |i| Array.new(11) { |_j| i.to_f } }
      p = UnicodePlot.heatmap(z, yfact: 0.1, yoffset: -0.5)
      test_ref("heatmap/scaling_11x11_yfact_0.1_yoffset_-0.5.txt", p)
    end

    # scaling_11x11_xfact_0.1_xoffset_-0.5_yfact_10_yoffset_-50
    it "matches heatmap/scaling_11x11_xfact_0.1_xoffset_-0.5_yfact_10_yoffset_-50" do
      z = Array.new(11) { |i| Array.new(11) { |_j| i.to_f } }
      p = UnicodePlot.heatmap(z, xfact: 0.1, xoffset: -0.5, yfact: 10.0, yoffset: -50.0)
      test_ref("heatmap/scaling_11x11_xfact_0.1_xoffset_-0.5_yfact_10_yoffset_-50.txt", p)
    end

    # limits_31x31: outer product 0:30 × 0:30 → A[i,j] = (i-1)*(j-1) in Julia = i*j in Crystal (0-indexed)
    it "matches heatmap/limits_31x31_ylim_10_20" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, ylim: {10.0, 20.0})
      test_ref("heatmap/limits_31x31_ylim_10_20.txt", p)
    end

    it "matches heatmap/limits_31x31_xlim_10_20" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, xlim: {10.0, 20.0})
      test_ref("heatmap/limits_31x31_xlim_10_20.txt", p)
    end

    it "matches heatmap/limits_31x31_xlim_10_20_ylim_10_20" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, xlim: {10.0, 20.0}, ylim: {10.0, 20.0})
      test_ref("heatmap/limits_31x31_xlim_10_20_ylim_10_20.txt", p)
    end

    it "matches heatmap/limits_31x31_ylim_50_50" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, ylim: {50.0, 50.0})
      test_ref("heatmap/limits_31x31_ylim_50_50.txt", p)
    end

    it "matches heatmap/limits_31x31_zlim_0_1800" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, zlim: {0.0, 1800.0})
      test_ref("heatmap/limits_31x31_zlim_0_1800.txt", p)
    end

    it "matches heatmap/limits_31x31_ylim_1_50" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, ylim: {1.0, 50.0})
      test_ref("heatmap/limits_31x31_ylim_1_50.txt", p)
    end

    it "matches heatmap/limits_31x31_xlim_1_50" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, xlim: {1.0, 50.0})
      test_ref("heatmap/limits_31x31_xlim_1_50.txt", p)
    end

    it "matches heatmap/limits_31x31_xlim_1_50_ylim_1_50" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, xlim: {1.0, 50.0}, ylim: {1.0, 50.0})
      test_ref("heatmap/limits_31x31_xlim_1_50_ylim_1_50.txt", p)
    end

    it "matches heatmap/limits_31x31_xlim_50_60" do
      z = Array.new(31) { |i| Array.new(31) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, xlim: {50.0, 60.0})
      test_ref("heatmap/limits_31x31_xlim_50_60.txt", p)
    end

    it "matches heatmap/parameters_60x60_colorbar_false" do
      z = Array.new(60) { |i| Array.new(60) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, colorbar: false)
      test_ref("heatmap/parameters_60x60_colorbar_false.txt", p)
    end

    it "matches heatmap/parameters_60x60_labels_false" do
      z = Array.new(60) { |i| Array.new(60) { |j| i.to_f * j.to_f } }
      p = UnicodePlot.heatmap(z, labels: false)
      test_ref("heatmap/parameters_60x60_labels_false.txt", p)
    end

    it "matches heatmap/parameters_60x60_title_hmap_zlabel_lab_colorbar_border_ascii_colormap_inferno" do
      z = heatmap_fixture_matrix("60x60")
      p = UnicodePlot.heatmap(z,
        title: "hmap", zlabel: "lab",
        colorbar_border: :ascii, colormap: :inferno)
      test_ref("heatmap/parameters_60x60_title_hmap_zlabel_lab_colorbar_border_ascii_colormap_inferno.txt", p)
    end

    it "matches heatmap/parameters_10x10_xfact_0.1" do
      z = heatmap_fixture_matrix("10x10")
      p = UnicodePlot.heatmap(z, xfact: 0.1)
      test_ref("heatmap/parameters_10x10_xfact_0.1.txt", p)
    end

    it "matches heatmap/parameters_10x10_yfact_1" do
      z = heatmap_fixture_matrix("10x10")
      p = UnicodePlot.heatmap(z, yfact: 1.0)
      test_ref("heatmap/parameters_10x10_yfact_1.txt", p)
    end

    it "matches heatmap/parameters_10x11_xfact_0.1" do
      z = heatmap_fixture_matrix("10x11")
      p = UnicodePlot.heatmap(z, xfact: 0.1)
      test_ref("heatmap/parameters_10x11_xfact_0.1.txt", p)
    end

    it "matches heatmap/parameters_10x11_yfact_1" do
      z = heatmap_fixture_matrix("10x11")
      p = UnicodePlot.heatmap(z, yfact: 1.0)
      test_ref("heatmap/parameters_10x11_yfact_1.txt", p)
    end
  end
end
