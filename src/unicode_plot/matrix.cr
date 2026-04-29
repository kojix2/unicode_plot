module UnicodePlot
  struct MatrixView(T)
    getter rows : Array(Array(T))
    getter nrows : Int32
    getter ncols : Int32

    def initialize(@rows : Array(Array(T)))
      @nrows = @rows.size
      @ncols = @rows.empty? ? 0 : @rows[0].size

      @rows.each_with_index do |row, i|
        unless row.size == @ncols
          raise ArgumentError.new(
            "matrix rows must all have the same length; row #{i} has #{row.size}, expected #{@ncols}"
          )
        end
      end
    end

    def empty? : Bool
      @nrows == 0 || @ncols == 0
    end

    def [](row : Int32, col : Int32) : T
      @rows[row][col]
    end

    def each_cell(& : Int32, Int32, T ->)
      @rows.each_with_index do |row_values, row|
        row_values.each_with_index do |value, col|
          yield row, col, value
        end
      end
    end
  end

  def matrix_axis_coords(
    n : Int32,
    fact : Float64?,
    offset : Float64 = 0.0,
  ) : Array(Float64)
    if fact.nil?
      Array.new(n) { |i| (i + 1).to_f64 + offset }
    else
      f = fact || 1.0
      Array.new(n) { |i| i.to_f64 * f + offset }
    end
  end

  # Returns {low_label, high_label} for matrix index coordinates.
  # Standard matrix indexing is 1..n; for 0-sized axes in Julia compatibility mode
  # we use 0..1 to reflect the plotted fallback range.
  def matrix_index_range_labels(
    size : Int32,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
    zero_fallback_range : Bool = true,
  ) : {String, String}
    if size == 0
      zero_fallback_range ? {"0", "1"} : {"1", "0"}
    else
      {"1", nice_repr(size, unicode_exponent, thousands_separator)}
    end
  end

  # Returns {left_label, right_label} for horizontal axis labels.
  def matrix_horizontal_axis_labels(
    size : Int32,
    *,
    flip : Bool,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
    zero_fallback_range : Bool = true,
  ) : {String, String}
    lo, hi = matrix_index_range_labels(size, unicode_exponent, thousands_separator, zero_fallback_range)
    flip ? {hi, lo} : {lo, hi}
  end

  # Returns {top_label, bottom_label} for vertical axis labels.
  def matrix_vertical_axis_labels(
    size : Int32,
    *,
    flip : Bool,
    unicode_exponent : Bool = true,
    thousands_separator : Char = ' ',
    zero_fallback_range : Bool = true,
  ) : {String, String}
    lo, hi = matrix_index_range_labels(size, unicode_exponent, thousands_separator, zero_fallback_range)
    flip ? {hi, lo} : {lo, hi}
  end

  def matrix_extrema_finite(matrix : MatrixView(T)) : {Float64, Float64}? forall T
    {% unless T <= Number %}
      {% raise "matrix_extrema_finite requires numeric matrix elements" %}
    {% end %}

    min_value = nil.as(Float64?)
    max_value = nil.as(Float64?)

    matrix.each_cell do |_row, _col, value|
      v = value.to_f64
      next unless v.finite?

      if min_value.nil?
        min_value = v
        max_value = v
      else
        current_min = min_value || v
        current_max = max_value || v
        min_value = v if v < current_min
        max_value = v if v > current_max
      end
    end

    return if min_value.nil?
    {min_value || 0.0, max_value || 0.0}
  end
end
