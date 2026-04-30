require "../support/reference_helpers"

describe "Julia reference output compatibility - boxplot" do
describe "boxplot" do
  it "matches boxplot/default" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0])
    test_ref("boxplot/default.txt", p)
  end

  it "matches boxplot/default_name" do
    p = UnicodePlot.boxplot("series1", [1.0, 2.0, 3.0, 4.0, 5.0])
    test_ref("boxplot/default_name.txt", p)
  end

  it "matches boxplot/scale1 (xlim 0..5)" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0], xlim: {0.0, 5.0})
    test_ref("boxplot/scale1.txt", p)
  end

  it "matches boxplot/scale2 (xlim 0..6)" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0], xlim: {0.0, 6.0})
    test_ref("boxplot/scale2.txt", p)
  end

  it "matches boxplot/scale3 (xlim 0..10)" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0], xlim: {0.0, 10.0})
    test_ref("boxplot/scale3.txt", p)
  end

  it "matches boxplot/scale4 (xlim 0..20)" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0], xlim: {0.0, 20.0})
    test_ref("boxplot/scale4.txt", p)
  end

  it "matches boxplot/scale5 (xlim 0..40)" do
    p = UnicodePlot.boxplot([1.0, 2.0, 3.0, 4.0, 5.0], xlim: {0.0, 40.0})
    test_ref("boxplot/scale5.txt", p)
  end

  it "matches boxplot/multi1 (two named series)" do
    p = UnicodePlot.boxplot(
      ["one", "two"],
      [[1.0, 2.0, 3.0, 4.0, 5.0], [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]],
      title: "Multi-series", xlabel: "foo", color: :yellow
    )
    test_ref("boxplot/multi1.txt", p)
  end

  it "matches boxplot/multi2 (after boxplot! appends third series)" do
    p = UnicodePlot.boxplot(
      ["one", "two"],
      [[1.0, 2.0, 3.0, 4.0, 5.0], [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]],
      title: "Multi-series", xlabel: "foo", color: :yellow
    )
    UnicodePlot.boxplot!(p, "one more", [-1.0, 2.0, 3.0, 4.0, 11.0])
    test_ref("boxplot/multi2.txt", p)
  end

  it "matches boxplot/multi3 (after second boxplot! with name kwarg)" do
    p = UnicodePlot.boxplot(
      ["one", "two"],
      [[1.0, 2.0, 3.0, 4.0, 5.0], [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]],
      title: "Multi-series", xlabel: "foo", color: :yellow
    )
    UnicodePlot.boxplot!(p, "one more", [-1.0, 2.0, 3.0, 4.0, 11.0])
    UnicodePlot.boxplot!(p, [4.0, 2.0, 2.5, 4.0, 14.0], name: "last one")
    test_ref("boxplot/multi3.txt", p)
  end

  it "matches boxplot/multi4 (unnamed multi-series)" do
    p = UnicodePlot.boxplot([[1.0, 2.0, 3.0, 4.0, 5.0], [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0]])
    test_ref("boxplot/multi4.txt", p)
  end
end

end
