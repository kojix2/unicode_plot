module UnicodePlot
  # Dot canvas — 2 vertical sub-pixels per character cell.
  # Upper sub-pixel → ''', lower sub-pixel → '.', both → ':', neither → ' '.
  class DotCanvas < Canvas
    # Indexed by bitmask: bit0=upper set, bit1=lower set
    DOT_CHARS  = [' ', '\'', '.', ':']
    EMPTY_CHAR = ' '

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
    )
      raise ArgumentError.new("`height` must be positive") unless height > 0
      raise ArgumentError.new("`width` must be positive") unless width > 0
      char_height = Math.max(char_height, 5)
      char_width = Math.max(char_width, 2)
      ys = yscale.is_a?(Symbol) ? UnicodePlot.scale_callback(yscale.as(Symbol)) : yscale.as(Proc(Float64, Float64))
      xs = xscale.is_a?(Symbol) ? UnicodePlot.scale_callback(xscale.as(Symbol)) : xscale.as(Proc(Float64, Float64))
      super(
        char_height, char_width,
        visible, blend, yflip, xflip,
        char_height * 2, char_width,
        origin_y, origin_x, height, width,
        ys, xs,
        0_u32
      )
    end

    def blank : Char
      EMPTY_CHAR
    end

    def y_pixel_per_char : Int32
      2
    end

    def x_pixel_per_char : Int32
      1
    end

    def pixel!(pixel_x : Int32, pixel_y : Int32, color : UInt32, blend : Bool) : self
      return self unless valid_x_pixel?(pixel_x) && valid_y_pixel?(pixel_y)

      px = pixel_x.clamp(0, @pixel_width - 1)
      py = pixel_y.clamp(0, @pixel_height - 1)

      char_col = px + 1
      char_row = py // 2 + 1

      return self unless 1 <= char_row <= @nrows && 1 <= char_col <= @ncols

      # bit 0 = upper sub-pixel (py even), bit 1 = lower sub-pixel (py odd)
      bit = py % 2 == 0 ? 1_u32 : 2_u32
      grid_set!(char_row, char_col, grid_at(char_row, char_col) | bit)
      set_color!(char_col, char_row, color, blend)
      self
    end

    def grid_char_at(row : Int32, col : Int32) : Char
      val = grid_at(row, col)
      val < 4 ? DOT_CHARS[val] : EMPTY_CHAR
    end
  end
end
