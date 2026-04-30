require "../support/reference_helpers"

describe "Julia reference output compatibility - stairs" do
  describe "stairs" do
    sx = [1.0, 2.0, 4.0, 7.0, 8.0]
    sy = [1.0, 3.0, 4.0, 2.0, 7.0]

    it "matches lineplot/stairs_post (default style)" do
      p = UnicodePlot.stairs(sx, sy)
      test_ref("lineplot/stairs_post.txt", p)
    end

    it "matches lineplot/stairs_pre" do
      p = UnicodePlot.stairs(sx, sy, style: :pre)
      test_ref("lineplot/stairs_pre.txt", p)
    end

    it "matches lineplot/stairs_parameters" do
      p = UnicodePlot.stairs(sx, sy, title: "Foo", color: :red, xlabel: "x", name: "1")
      UnicodePlot.stairs!(p, sx.map { |v| v - 0.2 }, sy.map { |v| v + 1.5 }, name: "2")
      test_ref("lineplot/stairs_parameters.txt", p)
    end

    it "matches lineplot/stairs_parameters2" do
      p = UnicodePlot.stairs(sx, sy, title: "Foo", color: :red, xlabel: "x", name: "1")
      UnicodePlot.stairs!(p, sx.map { |v| v - 0.2 }, sy.map { |v| v + 1.5 }, name: "2")
      UnicodePlot.stairs!(p, sx, sy, name: "3", style: :pre)
      test_ref("lineplot/stairs_parameters2.txt", p)
    end

    it "matches lineplot/stairs_parameters2_nocolor" do
      p = UnicodePlot.stairs(sx, sy, title: "Foo", color: :red, xlabel: "x", name: "1")
      UnicodePlot.stairs!(p, sx.map { |v| v - 0.2 }, sy.map { |v| v + 1.5 }, name: "2")
      UnicodePlot.stairs!(p, sx, sy, name: "3", style: :pre)
      test_ref("lineplot/stairs_parameters2_nocolor.txt", p)
    end

    it "matches lineplot/stairs_edgecase" do
      p = UnicodePlot.stairs([1.0, 2.0, 4.0, 7.0, 8.0], [1.0, 3.0, 4.0, 2.0, 7_000.0])
      test_ref("lineplot/stairs_edgecase.txt", p)
    end

    it "matches lineplot/squeeze_annotations" do
      p = UnicodePlot.stairs(sx, sy, width: 20)
      p.label!(:tl, "Hello")
      p.label!(:t, "how are")
      p.label!(:tr, "you?")
      p.label!(:bl, "Hello")
      p.label!(:b, "how are")
      p.label!(:br, "you?")
      UnicodePlot.lineplot!(p, 1, 0.5)
      test_ref("lineplot/squeeze_annotations.txt", p)
    end

    it "matches lineplot/stairs_date" do
      dx = (1..10).map { |day| Time.utc(2020, 8, day) }
      p = UnicodePlot.stairs(dx, (1..10).map(&.to_f64), xlim: {Time.utc(2020, 8, 1), Time.utc(2020, 8, 15)}, format: "%F")
      test_ref("lineplot/stairs_date.txt", p)
    end
  end
end
