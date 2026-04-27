module UnicodePlot
  def stairs(
    x : Array(Float64),
    y : Array(Float64),
    *,
    style : Symbol = :post,
    canvas : Symbol = :braille,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
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
    stairs!(plot, x, y, name: name, color: color, style: style)
    plot
  end

  def stairs(x : Array(Number), y : Array(Number), **kwargs) : Plot
    stairs(x.map(&.to_f), y.map(&.to_f), **kwargs)
  end

  def stairs(y : Array(Float64), **kwargs) : Plot
    stairs((1..y.size).map(&.to_f), y, **kwargs)
  end

  def stairs(y : Array(Number), **kwargs) : Plot
    stairs(y.map(&.to_f), **kwargs)
  end

  def stairs!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    *,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
    style : Symbol = :post,
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size

    c = color == :auto ? plot.next_color! : color
    col = plot_color(c)
    plot.label!(:r, name, col) unless name.empty?

    can = plot.canvas
    blend = can.blend?
    n = x.size

    (1...n).each do |i|
      x0, y0 = x[i - 1], y[i - 1]
      x1, y1 = x[i], y[i]
      next unless x0.finite? && y0.finite? && x1.finite? && y1.finite?

      if style == :post
        # horizontal from (x0,y0) to (x1,y0), then vertical to (x1,y1)
        can.lines!(x0, y0, x1, y0, col, blend)
        can.lines!(x1, y0, x1, y1, col, blend)
      else
        # :pre — vertical from (x0,y0) to (x0,y1), then horizontal to (x1,y1)
        can.lines!(x0, y0, x0, y1, col, blend)
        can.lines!(x0, y1, x1, y1, col, blend)
      end
    end

    plot.series += 1
    plot
  end

  def stairs!(plot : Plot, x : Array(Number), y : Array(Number), **kwargs) : Plot
    stairs!(plot, x.map(&.to_f), y.map(&.to_f), **kwargs)
  end
end
