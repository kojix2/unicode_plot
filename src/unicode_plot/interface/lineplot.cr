module UnicodePlot
  private def to_plot_f64(values : Array(T)) : Array(Float64) forall T
    {% unless T <= Number %}
      {% raise "to_plot_f64 requires numeric array elements" %}
    {% end %}
    values.map(&.to_f64)
  end

  def lineplot(
    x : Array(Float64),
    y : Array(Float64),
    *,
    canvas : Symbol = :braille,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
    head_tail : Symbol? = nil,
    head_tail_frac : Float64 = 0.05,
    title : String = "",
    xlabel : String = "",
    ylabel : String = "",
    xscale : Symbol | Proc(Float64, Float64) = :identity,
    yscale : Symbol | Proc(Float64, Float64) = :identity,
    height : Int32? = nil,
    width : Int32? = nil,
    border : Symbol = :solid,
    compact_labels : Bool = false,
    compact : Bool = false,
    blend : Bool = true,
    xlim : {Float64, Float64} = {0.0, 0.0},
    ylim : {Float64, Float64} = {0.0, 0.0},
    margin : Int32 = 3,
    padding : Int32 = 1,
    labels : Bool = true,
    grid : Bool = true,
    yticks : Bool = true,
    xticks : Bool = true,
    min_height : Int32 = 2,
    min_width : Int32 = 5,
    yflip : Bool = false,
    xflip : Bool = false,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size
    plot = build_plot(
      x, y,
      canvas_type: canvas,
      title: title, xlabel: xlabel, ylabel: ylabel,
      xscale: xscale, yscale: yscale,
      height: height, width: width,
      border: border, compact_labels: compact_labels, compact: compact,
      blend: blend, xlim: xlim, ylim: ylim,
      margin: margin, padding: padding,
      labels: labels, grid: grid, yticks: yticks, xticks: xticks,
      min_height: min_height, min_width: min_width,
      yflip: yflip, xflip: xflip,
      unicode_exponent: unicode_exponent, thousands_separator: thousands_separator
    )
    lineplot!(plot, x, y, name: name, color: color, head_tail: head_tail, head_tail_frac: head_tail_frac)
    plot
  end

  # Convenience overloads
  def lineplot(y : Array(Float64), **kwargs) : Plot
    x = (1..y.size).map(&.to_f)
    lineplot(x, y, **kwargs)
  end

  def lineplot(y : Array(T), **kwargs) : Plot forall T
    x = (1..y.size).map(&.to_f64)
    lineplot(x, to_plot_f64(y), **kwargs)
  end

  def lineplot(x : Array(Float64), f : Float64 -> Float64, **kwargs) : Plot
    lineplot(x, x.map { |v| f.call(v) }, **kwargs)
  end

  def lineplot(x : Array(T), f : Float64 -> Float64, **kwargs) : Plot forall T
    lineplot(to_plot_f64(x), f, **kwargs)
  end

  def lineplot(startx : Float64, endx : Float64, f : Float64 -> Float64, **kwargs) : Plot
    w = kwargs[:width]?.try(&.as(Int32)) || default_width
    n = 3 * w
    span = endx - startx
    x = (0..n).map { |i| startx + span * i.to_f / n }
    lineplot(x, f, **kwargs)
  end

  def lineplot(f : Float64 -> Float64, **kwargs) : Plot
    lineplot(-10.0, 10.0, f, **kwargs)
  end

  # Generic numeric overloads for lineplot
  def lineplot(x : Array(T), y : Array(U), **kwargs) : Plot forall T, U
    lineplot(to_plot_f64(x), to_plot_f64(y), **kwargs)
  end

  # ameba:disable Metrics/CyclomaticComplexity
  def lineplot!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    *,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
    head_tail : Symbol? = nil,
    head_tail_frac : Float64 = 0.05,
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size
    c = color == :auto ? plot.next_color! : color
    col = plot_color(c)
    plot.label!(:r, name, col) unless name.empty?
    nx = x.size
    plot.lines!(x, y, col, plot.canvas.blend?)
    if head_tail && nx > 0
      n = Math.min((head_tail_frac * nx).to_i32, nx - 1)
      comp = complement(col)
      callable = n > 0 ? :lines : :points
      if head_tail == :head || head_tail == :both
        xs_head = x[(nx - 1 - n)..]
        ys_head = y[(nx - 1 - n)..]
        if callable == :lines
          plot.lines!(xs_head, ys_head, comp, plot.canvas.blend?)
        else
          plot.points!(xs_head, ys_head, comp, plot.canvas.blend?)
        end
      end
      if head_tail == :tail || head_tail == :both
        xs_tail = x[..n]
        ys_tail = y[..n]
        if callable == :lines
          plot.lines!(xs_tail, ys_tail, comp, plot.canvas.blend?)
        else
          plot.points!(xs_tail, ys_tail, comp, plot.canvas.blend?)
        end
      end
    end
    plot.series += 1
    plot
  end

  def lineplot!(plot : Plot, x : Array(Float64), y : Array(Float64), **kwargs) : Plot
    lineplot!(plot, x, y, **kwargs.merge({name: "", color: :auto.as(Symbol | UInt32 | {Int32, Int32, Int32})}))
  end

  def lineplot!(plot : Plot, x : Array(T), y : Array(U), **kwargs) : Plot forall T, U
    lineplot!(plot, to_plot_f64(x), to_plot_f64(y), **kwargs)
  end

  def lineplot!(plot : Plot, y : Array(Float64), **kwargs) : Plot
    x = (1..y.size).map(&.to_f)
    lineplot!(plot, x, y, **kwargs)
  end

  def lineplot!(plot : Plot, f : Float64 -> Float64, **kwargs) : Plot
    can = plot.canvas
    n = 3 * can.ncols
    span = can.width
    x = (0..n).map { |i| can.origin_x + span * i.to_f / n }
    lineplot!(plot, x, x.map { |v| f.call(v) }, **kwargs)
  end

  def lineplot!(plot : Plot, startx : Float64, endx : Float64, f : Float64 -> Float64, **kwargs) : Plot
    n = 3 * plot.canvas.ncols
    span = endx - startx
    x = (0..n).map { |i| startx + span * i.to_f / n }
    lineplot!(plot, x, x.map { |v| f.call(v) }, **kwargs)
  end

  # vline! and hline! helpers
  def vline!(plot : Plot, x : Float64, y : Array(Float64)? = nil, **kwargs) : Plot
    can = plot.canvas
    ys = y || begin
      o = can.origin_y
      (0..can.nrows).map { |i| o + (i.to_f / can.nrows) * can.height }
    end
    lineplot!(plot, Array.new(ys.size, x), ys, **kwargs)
  end

  def hline!(plot : Plot, y : Float64, x : Array(Float64)? = nil, **kwargs) : Plot
    can = plot.canvas
    xs = x || begin
      o = can.origin_x
      (0..can.ncols).map { |i| o + (i.to_f / can.ncols) * can.width }
    end
    lineplot!(plot, xs, Array.new(xs.size, y), **kwargs)
  end

  # Private helper to draw lines on a canvas from arrays
  private def lineplot_lines!(plot : Plot, x : Array(Float64), y : Array(Float64), color : UInt32, blend : Bool) : Nil
    (1...x.size).each do |i|
      x1, y1 = x[i - 1], y[i - 1]
      x2, y2 = x[i], y[i]
      next unless x1.finite? && y1.finite? && x2.finite? && y2.finite?
      plot.canvas.lines!(x1, y1, x2, y2, color, blend)
    end
  end
end
