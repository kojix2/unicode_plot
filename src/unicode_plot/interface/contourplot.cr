module UnicodePlot
  def contourplot(
    z : Array(Array(Float64)),
    *,
    levels : Int32 | Array(Float64) = 3,
    canvas : Symbol = :braille,
    colormap : Symbol = :viridis,
    title : String = "",
    xlabel : String = "",
    ylabel : String = "",
    height : Int32? = nil,
    width : Int32? = nil,
    border : Symbol = :solid,
    compact_labels : Bool = false,
    compact : Bool = false,
    xlim : {Float64, Float64} = {0.0, 0.0},
    ylim : {Float64, Float64} = {0.0, 0.0},
    zlim : {Float64, Float64} = {0.0, 0.0},
    margin : Int32 = 3,
    padding : Int32 = 1,
    labels : Bool = true,
    min_height : Int32 = 2,
    min_width : Int32 = 5,
    xflip : Bool = false,
    yflip : Bool = false,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
  ) : Plot
    matrix = MatrixView.new(z)
    x = matrix_col_coords(matrix)
    y = matrix_reversed_row_coords(matrix)

    contourplot(
      x,
      y,
      z,
      levels: levels,
      canvas: canvas,
      colormap: colormap,
      title: title,
      xlabel: xlabel,
      ylabel: ylabel,
      height: height,
      width: width,
      border: border,
      compact_labels: compact_labels,
      compact: compact,
      xlim: xlim,
      ylim: ylim,
      zlim: zlim,
      margin: margin,
      padding: padding,
      labels: labels,
      min_height: min_height,
      min_width: min_width,
      xflip: xflip,
      yflip: yflip,
      unicode_exponent: unicode_exponent,
      thousands_separator: thousands_separator,
    )
  end

  def contourplot(
    x : Array(Float64),
    y : Array(Float64),
    z : Array(Array(Float64)),
    *,
    levels : Int32 | Array(Float64) = 3,
    canvas : Symbol = :braille,
    colormap : Symbol = :viridis,
    title : String = "",
    xlabel : String = "",
    ylabel : String = "",
    height : Int32? = nil,
    width : Int32? = nil,
    border : Symbol = :solid,
    compact_labels : Bool = false,
    compact : Bool = false,
    xlim : {Float64, Float64} = {0.0, 0.0},
    ylim : {Float64, Float64} = {0.0, 0.0},
    zlim : {Float64, Float64} = {0.0, 0.0},
    margin : Int32 = 3,
    padding : Int32 = 1,
    labels : Bool = true,
    min_height : Int32 = 2,
    min_width : Int32 = 5,
    xflip : Bool = false,
    yflip : Bool = false,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
  ) : Plot
    matrix = MatrixView.new(z)
    validate_matrix_axes!(matrix, x, y, "z")

    plot = build_plot(
      x,
      y,
      canvas_type: canvas,
      title: title,
      xlabel: xlabel,
      ylabel: ylabel,
      height: height,
      width: width,
      border: border,
      compact_labels: compact_labels,
      compact: compact,
      blend: false,
      xlim: xlim,
      ylim: ylim,
      margin: margin,
      padding: padding,
      labels: labels,
      grid: false,
      yticks: true,
      xticks: true,
      min_height: min_height,
      min_width: min_width,
      yflip: yflip,
      xflip: xflip,
      colorbar: true,
      colorbar_lim: {0.0, 1.0},
      unicode_exponent: unicode_exponent,
      thousands_separator: thousands_separator,
    )

    contourplot!(
      plot,
      x,
      y,
      matrix,
      levels: levels,
      colormap: colormap,
      zlim: zlim,
    )
  end

  def contourplot(
    z : Array(Array(T)),
    **kwargs,
  ) : Plot forall T
    {% if T <= Number %}
      contourplot(z.map { |row| to_plot_f64(row) }, **kwargs)
    {% else %}
      raise ArgumentError.new("contourplot(z) requires numeric matrix elements")
    {% end %}
  end

  def contourplot(
    x : Array(TX),
    y : Array(TY),
    z : Array(Array(TZ)),
    **kwargs,
  ) : Plot forall TX, TY, TZ
    {% if TX <= Number && TY <= Number && TZ <= Number %}
      contourplot(to_plot_f64(x), to_plot_f64(y), z.map { |row| to_plot_f64(row) }, **kwargs)
    {% else %}
      raise ArgumentError.new("contourplot(x, y, z) requires numeric arrays")
    {% end %}
  end

  def contourplot!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    z : Array(Array(Float64)),
    **kwargs,
  ) : Plot
    contourplot!(plot, x, y, MatrixView.new(z), **kwargs)
  end

  def contourplot!(
    plot : Plot,
    x : Array(Float64),
    y : Array(Float64),
    z : MatrixView(T),
    *,
    levels : Int32 | Array(Float64) = 3,
    colormap : Symbol = :viridis,
    zlim : {Float64, Float64} = {0.0, 0.0},
  ) : Plot forall T
    validate_matrix_axes!(z, x, y, "z")

    data_extrema = matrix_extrema_finite(z) || {0.0, 1.0}
    zmin, zmax = zlim == {0.0, 0.0} ? data_extrema : zlim

    levels_array = case levels
                   when Int32
                     if zlim == {0.0, 0.0}
                       Contour.contour_levels(z, levels)
                     else
                       Contour.contour_levels(zmin, zmax, levels)
                     end
                   else
                     levels
                   end

    # Keep interface coordinates natural for Crystal callers: (x, y, z).
    collection = Contour.contours(x, y, z, levels_array)

    callback = colormap_callback(colormap)
    plot.colormap.bar = true
    plot.colormap.lim = {zmin, zmax}
    plot.colormap.callback = callback

    collection.levels.each do |contour_level|
      color = callback.call(contour_level.level, zmin, zmax)
      contour_lines = contour_level.lines
      contour_lines.each do |curve|
        next if curve.vertices.size < 2

        xs, ys = contour_curve_xy(curve)

        lineplot!(plot, xs, ys, color: color)
      end
    end

    plot
  end

  def contourplot!(
    plot : Plot,
    x : Array(TX),
    y : Array(TY),
    z : Array(Array(TZ)),
    **kwargs,
  ) : Plot forall TX, TY, TZ
    {% if TX <= Number && TY <= Number && TZ <= Number %}
      contourplot!(plot, to_plot_f64(x), to_plot_f64(y), z.map { |row| to_plot_f64(row) }, **kwargs)
    {% else %}
      raise ArgumentError.new("contourplot!(x, y, z) requires numeric arrays")
    {% end %}
  end

  def contourplot!(
    plot : Plot,
    x : Array(TX),
    y : Array(TY),
    z : MatrixView(TZ),
    **kwargs,
  ) : Plot forall TX, TY, TZ
    {% if TX <= Number && TY <= Number %}
      contourplot!(plot, to_plot_f64(x), to_plot_f64(y), z, **kwargs)
    {% else %}
      raise ArgumentError.new("contourplot!(x, y, z) requires numeric x/y arrays")
    {% end %}
  end

  private def contour_curve_xy(curve : Contour::Curve2) : {Array(Float64), Array(Float64)}
    # Contour vertices are stored as (x, y).
    xs = Array(Float64).new(curve.vertices.size)
    ys = Array(Float64).new(curve.vertices.size)
    curve.vertices.each do |x_value, y_value|
      xs << x_value
      ys << y_value
    end
    {xs, ys}
  end
end
