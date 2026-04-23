module UnicodePlot
  # 2×2 pixel per character, encoded with block drawing characters.
  BLOCK_SIGNS = [
    [0b1000_u32, 0b0100_u32],
    [0b0010_u32, 0b0001_u32],
  ]

  BLOCK_DECODE = [
    ' ', '▗', '▖', '▄',
    '▝', '▐', '▞', '▟',
    '▘', '▚', '▌', '▙',
    '▀', '▜', '▛', '█',
  ]

  class BlockCanvas < Canvas
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
      ph = char_height * 2
      pw = char_width * 2
      ys = yscale.is_a?(Symbol) ? UnicodePlot.scale_callback(yscale.as(Symbol)) : yscale.as(Proc(Float64, Float64))
      xs = xscale.is_a?(Symbol) ? UnicodePlot.scale_callback(xscale.as(Symbol)) : xscale.as(Proc(Float64, Float64))
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
      2
    end

    def pixel!(pixel_x : Int32, pixel_y : Int32, color : UInt32, blend : Bool) : self
      return self unless valid_x_pixel?(pixel_x) && valid_y_pixel?(pixel_y)

      px = pixel_x >= @pixel_width ? pixel_x - 1 : pixel_x
      py = pixel_y >= @pixel_height ? pixel_y - 1 : pixel_y

      char_col = px // 2 + 1
      char_row = py // 2 + 1
      off_col = px % 2
      off_row = py % 2

      return self unless 1 <= char_row <= @nrows && 1 <= char_col <= @ncols

      val = grid_at(char_row, char_col)
      if val == 0 || val <= 0b1111_u32
        grid_set!(char_row, char_col, val | BLOCK_SIGNS[off_row][off_col])
      end
      set_color!(char_col, char_row, color, blend)
      self
    end

    def grid_char_at(row : Int32, col : Int32) : Char
      BLOCK_DECODE[grid_at(row, col).to_i]
    end
  end
end
