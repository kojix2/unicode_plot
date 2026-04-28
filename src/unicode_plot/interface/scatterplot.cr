module UnicodePlot
  def scatterplot(
    x : Array(Float64),
    y : Array(Float64),
    *,
    canvas : Symbol = :braille,
    name : String = "",
    color : PlotColor = :auto,
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
    xunit : String? = nil,
    yunit : String? = nil,
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size
    scatterplot(
      [x], [y],
      canvas: canvas,
      name: name,
      color: color,
      marker: marker,
      title: title,
      xlabel: unit_label(xlabel, xunit),
      ylabel: unit_label(ylabel, yunit),
      xscale: xscale,
      yscale: yscale,
      height: height,
      width: width,
      border: border,
      compact_labels: compact_labels,
      compact: compact,
      blend: blend,
      xlim: xlim,
      ylim: ylim,
      margin: margin,
      padding: padding,
      labels: labels,
      grid: grid,
      yticks: yticks,
      xticks: xticks,
      min_height: min_height,
      min_width: min_width,
      yflip: yflip,
      xflip: xflip,
      unicode_exponent: unicode_exponent,
      thousands_separator: thousands_separator,
      xunit: nil,
      yunit: nil,
    )
  end

  def scatterplot(
    x : Array(Array(Float64)),
    y : Array(Array(Float64)),
    *,
    canvas : Symbol = :braille,
    name : String = "",
    color : PlotColorArg = :auto,
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
    xunit : String? = nil,
    yunit : String? = nil,
  ) : Plot
    raise ArgumentError.new("x and y must have the same number of series") unless x.size == y.size
    if color.is_a?(Array)
      raise ArgumentError.new("color vector must have the same length as the number of series") unless color.size == x.size
    end

    x.each_with_index do |x_values, i|
      yv = y[i]
      raise ArgumentError.new("x and y series must have the same length") unless x_values.size == yv.size
    end

    flat_x = x.flatten
    flat_y = y.flatten
    xlabel_with_unit = unit_label(xlabel, xunit)
    ylabel_with_unit = unit_label(ylabel, yunit)
    plot = build_plot(
      flat_x, flat_y,
      canvas_type: canvas,
      title: title, xlabel: xlabel_with_unit, ylabel: ylabel_with_unit,
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

  def scatterplot(y : Array(Quantity), **kwargs) : Plot
    x = (1..y.size).map(&.to_f64)
    y_nu = number_unit(y)
    y_values = y_nu[0]
    y_unit = y_nu[1]
    opts = kwargs.merge({yunit: y_unit})
    scatterplot(x, y_values, **opts)
  end

  def scatterplot(y : Array(T), **kwargs) : Plot forall T
    x = (1..y.size).map(&.to_f64)
    scatterplot(x, to_plot_f64(y), **kwargs)
  end

  def scatterplot(x : Array(Quantity), y : Array(Quantity), **kwargs) : Plot
    x_nu = number_unit(x)
    x_values = x_nu[0]
    x_unit = x_nu[1]
    y_nu = number_unit(y)
    y_values = y_nu[0]
    y_unit = y_nu[1]
    opts = kwargs.merge({xunit: x_unit, yunit: y_unit})
    scatterplot(x_values, y_values, **opts)
  end

  def scatterplot(x : Array(T), y : Array(Quantity), **kwargs) : Plot forall T
    {% unless T <= Number %}
      {% raise "scatterplot(x, y_quantity) requires numeric x values" %}
    {% end %}
    y_nu = number_unit(y)
    y_values = y_nu[0]
    y_unit = y_nu[1]
    opts = kwargs.merge({yunit: y_unit})
    scatterplot(to_plot_f64(x), y_values, **opts)
  end

  def scatterplot(x : Array(Quantity), y : Array(T), **kwargs) : Plot forall T
    {% unless T <= Number %}
      {% raise "scatterplot(x_quantity, y) requires numeric y values" %}
    {% end %}
    x_nu = number_unit(x)
    x_values = x_nu[0]
    x_unit = x_nu[1]
    opts = kwargs.merge({xunit: x_unit})
    scatterplot(x_values, to_plot_f64(y), **opts)
  end

  def scatterplot(x : Array(T), y : Array(U), **kwargs) : Plot forall T, U
    scatterplot(to_plot_f64(x), to_plot_f64(y), **kwargs)
  end

  def scatterplot(x : Array(Array(T)), y : Array(Array(U)), **kwargs) : Plot forall T, U
    xs = x.map { |vals| to_plot_f64(vals) }
    ys = y.map { |vals| to_plot_f64(vals) }
    scatterplot(xs, ys, **kwargs)
  end

  def scatterplot!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    *,
    name : String = "",
    color : PlotColor = :auto,
    marker : Symbol | Char | String = :pixel,
  ) : Plot
    raise ArgumentError.new("x and y must have the same length") unless x.size == y.size
    scatterplot!(plot, [x], [y], name: name, color: color, marker: marker)
  end

  def scatterplot!(
    plot : Plot,
    x : Array(Array(Float64)),
    y : Array(Array(Float64)),
    *,
    name : String = "",
    color : PlotColorArg = :auto,
    marker : Symbol | Char | String = :pixel,
  ) : Plot
    raise ArgumentError.new("x and y must have the same number of series") unless x.size == y.size
    if color.is_a?(Array)
      raise ArgumentError.new("color vector must have the same length as the number of series") unless color.size == x.size
    end

    x.each_with_index do |x_values, i|
      yv = y[i]
      raise ArgumentError.new("x and y series must have the same length") unless x_values.size == yv.size

      series_color = color.is_a?(Array) ? color[i] : color
      scatterplot_single!(plot, x_values, yv, name: name, color: series_color, marker: marker)
    end
    plot
  end

  private def scatterplot_single!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    *,
    name : String = "",
    color : PlotColor = :auto,
    marker : Symbol | Char | String = :pixel,
  ) : Plot
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

  def scatterplot!(plot : Plot, x : Array(Quantity), y : Array(Quantity), **kwargs) : Plot
    x_values = number_unit(x)[0]
    y_values = number_unit(y)[0]
    scatterplot!(plot, x_values, y_values, **kwargs)
  end

  def scatterplot!(plot : Plot, x : Array(T), y : Array(Quantity), **kwargs) : Plot forall T
    {% unless T <= Number %}
      {% raise "scatterplot!(x, y_quantity) requires numeric x values" %}
    {% end %}
    y_values = number_unit(y)[0]
    scatterplot!(plot, to_plot_f64(x), y_values, **kwargs)
  end

  def scatterplot!(plot : Plot, x : Array(Quantity), y : Array(T), **kwargs) : Plot forall T
    {% unless T <= Number %}
      {% raise "scatterplot!(x_quantity, y) requires numeric y values" %}
    {% end %}
    x_values = number_unit(x)[0]
    scatterplot!(plot, x_values, to_plot_f64(y), **kwargs)
  end

  def scatterplot!(plot : Plot, x : Array(Array(T)), y : Array(Array(U)), **kwargs) : Plot forall T, U
    xs = x.map { |vals| to_plot_f64(vals) }
    ys = y.map { |vals| to_plot_f64(vals) }
    scatterplot!(plot, xs, ys, **kwargs)
  end

  def scatterplot!(plot : Plot, y : Array(T), **kwargs) : Plot forall T
    x = (1..y.size).map(&.to_f64)
    scatterplot!(plot, x, to_plot_f64(y), **kwargs)
  end

  def scatterplot!(plot : Plot, y : Array(Quantity), **kwargs) : Plot
    x = (1..y.size).map(&.to_f64)
    y_values = number_unit(y)[0]
    scatterplot!(plot, x, y_values, **kwargs)
  end
end
