require "../support/reference_helpers"

describe "Julia reference output compatibility - spy" do
describe "spy" do
  describe "flip" do
    a = spy_flip_matrix

    it "matches spy/flip_xflip-false_yflip-true" do
      p = UnicodePlot.spy(a, xflip: false, yflip: true)
      test_ref("spy/flip_xflip-false_yflip-true.txt", p)
    end

    it "matches spy/flip_xflip-true_yflip-false" do
      p = UnicodePlot.spy(a, xflip: true, yflip: false)
      test_ref("spy/flip_xflip-true_yflip-false.txt", p)
    end

    it "matches spy/flip_xflip-false_yflip-false" do
      p = UnicodePlot.spy(a, xflip: false, yflip: false)
      test_ref("spy/flip_xflip-false_yflip-false.txt", p)
    end

    it "matches spy/flip_xflip-true_yflip-true" do
      p = UnicodePlot.spy(a, xflip: true, yflip: true)
      test_ref("spy/flip_xflip-true_yflip-true.txt", p)
    end
  end

  describe "sizing" do
    it "matches spy/default_0x0" do
      a = Array(Array(Float64)).new(0) { Array(Float64).new(0, 0.0) }
      p = UnicodePlot.spy(a)
      test_ref("spy/default_0x0.txt", p)
    end

    it "matches spy/default_10x10" do
      p = UnicodePlot.spy(spy_fixture_matrix("10x10"))
      test_ref("spy/default_10x10.txt", p)
    end

    it "matches spy/default_10x15" do
      p = UnicodePlot.spy(spy_fixture_matrix("10x15"))
      test_ref("spy/default_10x15.txt", p)
    end

    it "matches spy/default_15x10" do
      p = UnicodePlot.spy(spy_fixture_matrix("15x10"))
      test_ref("spy/default_15x10.txt", p)
    end

    it "matches spy/default_200x200_normal" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"))
      test_ref("spy/default_200x200_normal.txt", p)
    end

    it "matches spy/default_200x200_normal_nocolor" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"))
      test_ref("spy/default_200x200_normal_nocolor.txt", p)
    end

    it "matches spy/default_200x200_normal_small (width: 10)" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"), width: 10)
      test_ref("spy/default_200x200_normal_small.txt", p)
    end

    it "matches spy/default_200x200_normal_misshaped (height: 5, width: 20)" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"), height: 5, width: 20)
      test_ref("spy/default_200x200_normal_misshaped.txt", p)
    end

    it "matches spy/default_2000x200" do
      p = UnicodePlot.spy(spy_fixture_matrix("2000x200"))
      test_ref("spy/default_2000x200.txt", p)
    end

    it "matches spy/default_200x2000" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x2000"))
      test_ref("spy/default_200x2000.txt", p)
    end
  end

  describe "parameters" do
    it "matches spy/parameters_200x200_green" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"), color: :green)
      test_ref("spy/parameters_200x200_green.txt", p)
    end

    it "matches spy/parameters_200x200_green_nocolor" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"), color: :green)
      test_ref("spy/parameters_200x200_green_nocolor.txt", p)
    end

    it "matches spy/parameters_200x200_dotcanvas" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_normal"), canvas: :dot, border: :ascii, title: "Custom Title")
      test_ref("spy/parameters_200x200_dotcanvas.txt", p)
    end

    it "matches spy/parameters_200x200_zeros" do
      p = UnicodePlot.spy(spy_fixture_matrix("200x200_zeros"), show_zeros: true, compact_labels: true)
      test_ref("spy/parameters_200x200_zeros.txt", p)
    end
  end

  describe "fix_aspect_ratio" do
    it "matches spy/fix_aspect_ratio_80x80_" do
      p = UnicodePlot.spy(spy_fixture_matrix("80x80"), fix_ar: true)
      test_ref("spy/fix_aspect_ratio_80x80_.txt", p)
    end
  end
end

end
