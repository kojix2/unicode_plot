module UnicodePlot
  # Braille dot offsets within a 4×2 pixel cell.
  # Index: [pixel_row_offset][pixel_col_offset] (1-based)
  BRAILLE_SIGNS = [
    [0x01_u32, 0x08_u32], # row 1: col1=⠁ col2=⠈
    [0x02_u32, 0x10_u32], # row 2: col1=⠂ col2=⠐
    [0x04_u32, 0x20_u32], # row 3: col1=⠄ col2=⠠
    [0x40_u32, 0x80_u32], # row 4: col1=⡀ col2=⢀
  ]

  class BrailleCanvas < Canvas
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
      char_height = Math.max(char_height, 2)
      char_width = Math.max(char_width, 5)
      ph = char_height * 4 # y_pixel_per_char = 4
      pw = char_width * 2  # x_pixel_per_char = 2
      ys = yscale.is_a?(Symbol) ? UnicodePlot.scale_callback(yscale.as(Symbol)) : yscale.as(Proc(Float64, Float64))
      xs = xscale.is_a?(Symbol) ? UnicodePlot.scale_callback(xscale.as(Symbol)) : xscale.as(Proc(Float64, Float64))
      super(
        char_height, char_width,
        visible, blend, yflip, xflip,
        ph, pw,
        origin_y, origin_x, height, width,
        ys, xs,
        BLANK_BRAILLE
      )
    end

    def blank : Char
      '⠀'
    end

    def y_pixel_per_char : Int32
      4
    end

    def x_pixel_per_char : Int32
      2
    end

    def pixel!(pixel_x : Int32, pixel_y : Int32, color : UInt32, blend : Bool) : self
      return self unless valid_x_pixel?(pixel_x) && valid_y_pixel?(pixel_y)

      # Clamp boundary case
      px = pixel_x >= @pixel_width ? pixel_x - 1 : pixel_x
      py = pixel_y >= @pixel_height ? pixel_y - 1 : pixel_y

      char_col = px // 2 + 1 # 1-based column in grid
      char_row = py // 4 + 1 # 1-based row in grid
      off_col = px % 2       # 0 or 1
      off_row = py % 4       # 0..3

      return self unless 1 <= char_row <= @nrows && 1 <= char_col <= @ncols

      val = grid_at(char_row, char_col)
      if BLANK_BRAILLE <= val <= FULL_BRAILLE
        grid_set!(char_row, char_col, val | BRAILLE_SIGNS[off_row][off_col])
      end
      set_color!(char_col, char_row, color, blend)
      self
    end

    def grid_char_at(row : Int32, col : Int32) : Char
      grid_at(row, col).chr
    end
  end

  # BrailleCanvas variant where blank is a space instead of ⠀.
  # Used for vertical histograms so that title/xlabel decorations render cleanly.
  class VHistCanvas < BrailleCanvas
    def blank : Char
      ' '
    end
  end
end
