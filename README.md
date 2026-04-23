# unicode_plot.cr

[![Test](https://github.com/kojix2/unicode_plot/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/unicode_plot/actions/workflows/test.yml)

Unicode terminal plots for Crystal — a port of Julia's [UnicodePlots.jl](https://github.com/JuliaPlots/UnicodePlots.jl).

The code was ported from Julia using an AI tool

🚧 **UNDER CONSTRUCTION** 🚧 Until the first version is released, this repository will be updated by force push.

## Installation

Add to your `shard.yml`:

```yaml
dependencies:
  unicode_plot:
    github: kojix2/unicode_plot
```

Then run `shards install`.

## Usage

```crystal
require "unicode_plot"
include UnicodePlot
```

### Line plot

```crystal
x = (0..62).map { |i| i * Math::PI / 31.0 }
y = x.map { |v| Math.sin(v) }
puts lineplot(x, y, title: "sin(x)", xlabel: "x", ylabel: "sin(x)", color: :blue)
```

### Scatter plot

```crystal
x1 = (1..15).map { Random.rand * 3.0 + 1.0 }
y1 = (1..15).map { Random.rand * 3.0 + 1.0 }
x2 = (1..15).map { Random.rand * 3.0 + 6.0 }
y2 = (1..15).map { Random.rand * 3.0 + 6.0 }

p = scatterplot(x1, y1, name: "cluster A", color: :blue,
  title: "Two clusters", xlim: {0.0, 11.0}, ylim: {0.0, 11.0})
scatterplot!(p, x2, y2, name: "cluster B", color: :red)
puts p
```

### Bar plot

```crystal
cities  = ["Tokyo", "Delhi", "Shanghai", "São Paulo", "Mexico City"]
popmill = [13.96, 16.79, 24.18, 12.33, 9.21]
puts barplot(cities, popmill, title: "City populations", xlabel: "population [mil]")
```

You can also pass a `Hash(String, Float64)` directly (sorted by key):

```crystal
puts barplot({"Ruby" => 95.0, "Python" => 98.0, "Crystal" => 72.0}, title: "Scores")
```

### Histogram

```crystal
data = (1..500).map { Random.rand * 10.0 }
puts histogram(data, title: "Uniform [0, 10)", nbins: 15)
```

### Multiple series / incremental plots

All plot types support a mutating `!` variant for adding series to an existing plot:

```crystal
x = (1..20).map(&.to_f)
p = lineplot(x, x.map { |v| Math.sqrt(v) }, name: "√x", color: :green, title: "Functions")
lineplot!(p, x, x.map { |v| Math.log(v) }, name: "ln(x)", color: :red)
puts p
```

### Options

| Option              | Description                                                                             |
| ------------------- | --------------------------------------------------------------------------------------- |
| `title`             | Plot title                                                                              |
| `xlabel` / `ylabel` | Axis labels                                                                             |
| `xlim` / `ylim`     | Axis limits as `{min, max}` tuple                                                       |
| `color`             | Line/point color (`:red`, `:blue`, `:green`, `:cyan`, `:magenta`, `:yellow`, `:normal`) |
| `name`              | Series name (shown in legend)                                                           |
| `xscale` / `yscale` | Scale function (`:log2`, `:log10`, or a `Proc(Float64, Float64)`)                       |
| `width` / `height`  | Canvas size in characters                                                               |
| `canvas`            | Canvas type (`:braille`, `:block`, `:ascii`)                                            |

See `examples/` for runnable demos.

## License

MIT — see [LICENSE](LICENSE).
