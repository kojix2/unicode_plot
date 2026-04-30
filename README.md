# unicode_plot.cr

[![Test](https://github.com/kojix2/unicode_plot/actions/workflows/test.yml/badge.svg)](https://github.com/kojix2/unicode_plot/actions/workflows/test.yml)
[![Lines of Code](https://img.shields.io/endpoint?url=https%3A%2F%2Ftokei.kojix2.net%2Fbadge%2Fgithub%2Fkojix2%2Funicode_plot%2Flines)](https://tokei.kojix2.net/github/kojix2/unicode_plot)

Unicode terminal plots for Crystal, ported from Julia's [UnicodePlots.jl](https://github.com/JuliaPlots/UnicodePlots.jl).

🚧 **UNDER CONSTRUCTION** 🚧

- Before the first release, history may be rewritten (force-push).
- API and behavior are still being aligned with UnicodePlots.jl.

## Current coverage

Implemented plot interfaces:

- `lineplot`, `lineplot!`
- `scatterplot`, `scatterplot!`
- `barplot`
- `histogram`
- `boxplot`
- `densityplot`, `densityplot!`
- `heatmap`
- `spy`
- `polarplot`, `polarplot!`
- `stairs`, `stairs!`
- `contourplot`, `contourplot!` (experimental)

See [examples/](examples/) for runnable scripts.

- Contour example: [examples/contourplot.cr](examples/contourplot.cr)

## Installation

Add to your `shard.yml`:

```yaml
dependencies:
  unicode_plot:
    github: kojix2/unicode_plot.cr
```

Then run `shards install`.

## Quick start

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

### Polar plot

```crystal
theta = (0...40).map { |i| 4.0 * Math::PI * i.to_f64 / 39.0 }
r = theta.map { |angle| angle / (2.0 * Math::PI) }
puts polarplot(theta, r, title: "Polar line", color: :green)
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

### Add series incrementally (`!` variants)

Most series-based plot types support a mutating `!` variant:

```crystal
x = (1..20).map(&.to_f)
p = lineplot(x, x.map { |v| Math.sqrt(v) }, name: "√x", color: :green, title: "Functions")
lineplot!(p, x, x.map { |v| Math.log(v) }, name: "ln(x)", color: :red)
puts p
```

### Time x-axis (experimental)

`lineplot` and `stairs` can accept `Array(Time)` for the x-axis. This API is experimental and currently requires an explicit Crystal `Time#to_s` format string:

```crystal
dates = (0..10).map { |i| Time.utc(2020, 1, 1) + i.days }
puts lineplot(dates, dates.map_with_index { |_, i| i.to_f }, format: "%F")
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

## Practical notes

- This project prioritizes Julia compatibility in visible output.
- Some interfaces may still differ while ports are in progress.
- `spec/reference_spec.cr` compares output against Julia reference assets.

## Development

Run specs from repository root:

```bash
crystal spec
```

Reference fixtures are stored under [spec/fixtures/](spec/fixtures/).

## License

MIT — see [LICENSE](LICENSE).
