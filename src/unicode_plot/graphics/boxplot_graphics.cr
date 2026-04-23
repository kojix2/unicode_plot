module UnicodePlot
  # Five-number summary per box, matching Julia UnicodePlots BoxplotGraphics.
  class BoxplotGraphics < GraphicsArea
    struct BoxData
      getter minimum : Float64
      getter lower_quartile : Float64
      getter median : Float64
      getter upper_quartile : Float64
      getter maximum : Float64
      getter color : UInt32

      def initialize(
        @minimum : Float64,
        @lower_quartile : Float64,
        @median : Float64,
        @upper_quartile : Float64,
        @maximum : Float64,
        @color : UInt32,
      )
      end
    end

    getter boxes : Array(BoxData)
    getter ncols : Int32
    getter? visible : Bool
    property xmin : Float64
    property xmax : Float64

    def initialize(@ncols : Int32, @xmin : Float64, @xmax : Float64, @visible : Bool = true)
      @boxes = [] of BoxData
    end

    def nrows : Int32
      @boxes.size * 3
    end

    def blank : Char
      ' '
    end

    def add_box!(data : Array(Float64), color : UInt32) : self
      raise ArgumentError.new("cannot add empty data to boxplot") if data.empty?
      sorted = data.sort
      @boxes << BoxData.new(
        sorted.first,
        percentile(sorted, 25.0),
        percentile(sorted, 50.0),
        percentile(sorted, 75.0),
        sorted.last,
        color,
      )
      self
    end

    def preprocess(io : IO) : GraphicsArea ->
      ->(_g : GraphicsArea) { }
    end

    private def percentile(sorted : Array(Float64), p : Float64) : Float64
      n = sorted.size
      return sorted[0] if n <= 1
      rank = p / 100.0 * (n - 1)
      lo = rank.floor.to_i32
      hi = (lo + 1).clamp(0, n - 1)
      lo == hi ? sorted[lo] : sorted[lo] + (rank - lo) * (sorted[hi] - sorted[lo])
    end

    # Map a data value to a 1-based column index (matches Julia's transform).
    private def val_to_col(val : Float64) : Int32
      r = @xmax - @xmin
      return (@ncols / 2.0).ceil.to_i32.clamp(1, @ncols) if r == 0.0
      col = ((val - @xmin) / r * @ncols).round.to_i32
      col.clamp(1, @ncols)
    end

    private def set!(buf : Array(Char), col : Array(UInt32), c : Int32, ch : Char, color : UInt32) : Nil
      idx = c - 1
      return unless 0 <= idx < buf.size
      buf[idx] = ch
      col[idx] = color
    end

    # Rendering matches Julia UnicodePlots print_row for BoxplotGraphics.
    # Each box occupies 3 rows (top, mid, bot).  Characters per sub-row:
    #   top: ╷  ┌─┬─┐  ╷
    #   mid: ├──┤ │ ├──┤
    #   bot: ╵  └─┴─┘  ╵
    def print_row(io : IO, row : Int32, use_color : Bool) : Nil
      box_idx = (row - 1) // 3
      sub_row = (row - 1) % 3 # 0=top, 1=mid, 2=bot
      b = @boxes[box_idx]

      # Characters indexed by sub_row: [top, mid, bot]
      min_ch = ['\u{2577}', '\u{251C}', '\u{2575}'][sub_row] # ╷ ├ ╵
      line_ch = [' ', '─', ' '][sub_row]
      left_box = ['\u{250C}', '\u{2524}', '\u{2514}'][sub_row] # ┌ ┤ └
      line_box = ['─', ' ', '─'][sub_row]
      median_ch = ['\u{252C}', '\u{2502}', '\u{2534}'][sub_row] # ┬ │ ┴
      right_box = ['\u{2510}', '\u{251C}', '\u{2518}'][sub_row] # ┐ ├ ┘
      max_ch = ['\u{2577}', '\u{2524}', '\u{2575}'][sub_row]    # ╷ ┤ ╵

      buf = Array(Char).new(@ncols, ' ')
      col_arr = Array(UInt32).new(@ncols, INVALID_COLOR)

      c_min = val_to_col(b.minimum)
      c_q1 = val_to_col(b.lower_quartile)
      c_med = val_to_col(b.median)
      c_q3 = val_to_col(b.upper_quartile)
      c_max = val_to_col(b.maximum)

      # Position characters (drawn last so they always appear)
      set!(buf, col_arr, c_min, min_ch, b.color)
      set!(buf, col_arr, c_q1, left_box, b.color)
      set!(buf, col_arr, c_med, median_ch, b.color)
      set!(buf, col_arr, c_q3, right_box, b.color)
      set!(buf, col_arr, c_max, max_ch, b.color)

      # Fill gaps with line characters
      ((c_min + 1)...c_q1).each { |i| set!(buf, col_arr, i, line_ch, b.color) }
      ((c_q1 + 1)...c_med).each { |i| set!(buf, col_arr, i, line_box, b.color) }
      ((c_med + 1)...c_q3).each { |i| set!(buf, col_arr, i, line_box, b.color) }
      ((c_q3 + 1)...c_max).each { |i| set!(buf, col_arr, i, line_ch, b.color) }

      buf.each_with_index { |cell_char, i| UnicodePlot.print_color(io, col_arr[i], cell_char.to_s, use_color) }
    end
  end
end
