module UnicodePlot
  DENSITY_CHARS = [' ', '░', '▒', '▓', '█']

  # 2D point-density canvas.  Each character cell accumulates a hit count;
  # at render time the count is normalised to the 5-level density palette.
  # Matches Julia UnicodePlots DensityCanvas: y_pixel_per_char=2, x_pixel_per_char=1.
  class DensityCanvas < Canvas
    @dscale : Proc(Float64, Float64)
    @max_density : Float64

    def initialize(
      char_height : Int32,
      char_width : Int32,
      *,
      visible : Bool = true,
      blend : Bool = true,
      origin_y : Float64 = 0.0,
      origin_x : Float64 = 0.0,
      height : Float64 = 1.0,
      width : Float64 = 1.0,
      yflip : Bool = false,
      xflip : Bool = false,
      yscale : Symbol | Proc(Float64, Float64) = :identity,
      xscale : Symbol | Proc(Float64, Float64) = :identity,
      dscale : Symbol | Proc(Float64, Float64) = :identity,
    )
      raise ArgumentError.new("`height` must be positive") unless height > 0
      raise ArgumentError.new("`width` must be positive") unless width > 0
      char_height = Math.max(char_height, 5)
      char_width = Math.max(char_width, 5)
      ph = char_height * 2 # y_pixel_per_char = 2
      pw = char_width * 1  # x_pixel_per_char = 1
      ys = yscale.is_a?(Symbol) ? UnicodePlot.scale_callback(yscale.as(Symbol)) : yscale.as(Proc(Float64, Float64))
      xs = xscale.is_a?(Symbol) ? UnicodePlot.scale_callback(xscale.as(Symbol)) : xscale.as(Proc(Float64, Float64))
      @dscale = dscale.is_a?(Symbol) ? UnicodePlot.scale_callback(dscale.as(Symbol)) : dscale.as(Proc(Float64, Float64))
      @max_density = 0.0
      super(
        char_height, char_width,
        visible, blend, yflip, xflip,
        ph, pw,
        origin_y, origin_x, height, width,
        ys, xs,
        0_u32
      )
    end

    def blank : Char
      ' '
    end

    def y_pixel_per_char : Int32
      2
    end

    def x_pixel_per_char : Int32
      1
    end

    def pixel!(pixel_x : Int32, pixel_y : Int32, color : UInt32, blend : Bool) : self
      return self unless valid_x_pixel?(pixel_x) && valid_y_pixel?(pixel_y)

      px = pixel_x >= @pixel_width ? pixel_x - 1 : pixel_x
      py = pixel_y >= @pixel_height ? pixel_y - 1 : pixel_y

      char_col = px + 1      # x_pixel_per_char = 1: one pixel per column
      char_row = py // 2 + 1 # y_pixel_per_char = 2

      return self unless 1 <= char_row <= @nrows && 1 <= char_col <= @ncols

      grid_set!(char_row, char_col, grid_at(char_row, char_col) + 1)
      set_color!(char_col, char_row, color, blend)
      self
    end

    def preprocess(io : IO) : GraphicsArea ->
      max_count = 0_u32
      (1..@nrows).each do |row_idx|
        (1..@ncols).each do |col_idx|
          v = grid_at(row_idx, col_idx)
          max_count = v if v > max_count
        end
      end
      @max_density = Math.max(1e-300, @dscale.call(max_count.to_f))
      ->(_g : GraphicsArea) { }
    end

    def grid_char_at(row : Int32, col : Int32) : Char
      count = grid_at(row, col)
      return ' ' if count == 0
      val = @dscale.call(count.to_f) / @max_density * (DENSITY_CHARS.size - 1)
      idx = val.round.to_i32.clamp(0, DENSITY_CHARS.size - 1)
      DENSITY_CHARS[idx]
    end
  end
end
