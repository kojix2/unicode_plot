module UnicodePlot
  def scatterplot(
    x : Array(Float64),
    y : Array(Float64),
    *,
    canvas : Symbol = :braille,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
    marker : Symbol | Char | String = :pixel,
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
    scatterplot!(plot, x, y, name: name, color: color, marker: marker)
    plot
  end

  def scatterplot(y : Array(Float64), **kwargs) : Plot
    x = (1..y.size).map(&.to_f)
    scatterplot(x, y, **kwargs)
  end

  def scatterplot(y : Array(T), **kwargs) : Plot forall T
    x = (1..y.size).map(&.to_f64)
    scatterplot(x, to_plot_f64(y), **kwargs)
  end

  def scatterplot(x : Array(T), y : Array(U), **kwargs) : Plot forall T, U
    scatterplot(to_plot_f64(x), to_plot_f64(y), **kwargs)
  end

  def scatterplot!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    *,
    name : String = "",
    color : Symbol | UInt32 | {Int32, Int32, Int32} = :auto,
    marker : Symbol | Char | String = :pixel,
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size
    c = color == :auto ? plot.next_color! : color
    col = plot_color(c)
    plot.label!(:r, name, col) unless name.empty?

    if marker == :pixel || marker == :auto
      plot.points!(x, y, col, plot.canvas.blend?)
    else
      mk = char_marker(marker.is_a?(Symbol) ? marker.as(Symbol) : marker.is_a?(Char) ? marker.as(Char) : marker.as(String))
      x.each_with_index do |xval, i|
        yi = y[i]
        next unless xval.finite? && yi.finite?
        plot.canvas.annotate!(xval, yi, mk, col, plot.canvas.blend?)
      end
    end
    plot.series += 1
    plot
  end

  def scatterplot!(plot : Plot, x : Array(T), y : Array(U), **kwargs) : Plot forall T, U
    scatterplot!(plot, to_plot_f64(x), to_plot_f64(y), **kwargs)
  end

  def scatterplot!(plot : Plot, y : Array(Float64), **kwargs) : Plot
    x = (1..y.size).map(&.to_f)
    scatterplot!(plot, x, y, **kwargs)
  end
end
