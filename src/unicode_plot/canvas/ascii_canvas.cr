module UnicodePlot
  # 3×3 pixel grid per character cell — 9-bit pattern per cell (bit 8 = top-left).
  # Matches Julia UnicodePlots AsciiCanvas (y_pixel_per_char=3, x_pixel_per_char=3).
  ASCII_SIGNS_3X3 = [
    [0b100_000_000_u32, 0b010_000_000_u32, 0b001_000_000_u32],
    [0b000_100_000_u32, 0b000_010_000_u32, 0b000_001_000_u32],
    [0b000_000_100_u32, 0b000_000_010_u32, 0b000_000_001_u32],
  ]

  # Exact 9-bit → character mappings from Julia's ASCII_LOOKUP.
  ASCII_LOOKUP_MAP = {
    0b101_000_000_u32 => '"',
    0b111_111_111_u32 => '@',
    0b010_000_000_u32 => '\'',
    0b010_100_010_u32 => '(',
    0b010_001_010_u32 => ')',
    0b000_010_000_u32 => '*',
    0b010_111_010_u32 => '+',
    0b000_010_010_u32 => ',',
    0b000_100_100_u32 => ',',
    0b000_001_001_u32 => ',',
    0b000_111_000_u32 => '-',
    0b000_000_010_u32 => '.',
    0b000_000_100_u32 => '.',
    0b000_000_001_u32 => '.',
    0b001_010_100_u32 => '/',
    0b010_100_000_u32 => '/',
    0b001_010_110_u32 => '/',
    0b011_010_010_u32 => '/',
    0b001_010_010_u32 => '/',
    0b110_010_111_u32 => '1',
    0b010_000_010_u32 => ':',
    0b111_000_111_u32 => '=',
    0b111_010_111_u32 => 'I',
    0b100_100_111_u32 => 'L',
    0b111_010_010_u32 => 'T',
    0b101_101_010_u32 => 'V',
    0b101_010_101_u32 => 'X',
    0b101_010_010_u32 => 'Y',
    0b110_100_110_u32 => '[',
    0b010_001_000_u32 => '\\',
    0b100_010_001_u32 => '\\',
    0b110_010_010_u32 => '\\',
    0b100_010_011_u32 => '\\',
    0b100_010_010_u32 => '\\',
    0b011_001_011_u32 => ']',
    0b010_101_000_u32 => '^',
    0b000_000_111_u32 => '_',
    0b100_000_000_u32 => '`',
    0b110_010_011_u32 => 'l',
    0b000_111_100_u32 => 'r',
    0b000_101_010_u32 => 'v',
    0b011_110_011_u32 => '{',
    0b010_010_010_u32 => '|',
    0b100_100_100_u32 => '|',
    0b001_001_001_u32 => '|',
    0b110_011_110_u32 => '}',
  }

  # Full 512-entry decode table built at startup.
  # For unmapped patterns, the closest entry by Hamming distance is used.
  ASCII_DECODE_512 = begin
    table = Array(Char).new(512, ' ')
    # Sort lookup keys for deterministic tie-breaking
    sorted_lookup = ASCII_LOOKUP_MAP.to_a.sort_by { |k, _v| k }
    (0_u32...512_u32).each do |pattern|
      if pattern == 0
        table[pattern] = ' '
      elsif ASCII_LOOKUP_MAP.has_key?(pattern)
        table[pattern] = ASCII_LOOKUP_MAP[pattern]
      else
        best_char = ' '
        best_dist = Int32::MAX
        sorted_lookup.each do |(k, v)|
          dist = 0
          x = pattern ^ k
          while x != 0
            dist += 1 if (x & 1) != 0
            x >>= 1
          end
          if dist < best_dist
            best_dist = dist
            best_char = v
          end
        end
        table[pattern] = best_char
      end
    end
    table
  end

  class AsciiCanvas < Canvas
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
      ph = char_height * 3 # y_pixel_per_char = 3
      pw = char_width * 3  # x_pixel_per_char = 3
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
      3
    end

    def x_pixel_per_char : Int32
      3
    end

    def pixel!(pixel_x : Int32, pixel_y : Int32, color : UInt32, blend : Bool) : self
      return self unless valid_x_pixel?(pixel_x) && valid_y_pixel?(pixel_y)

      px = pixel_x >= @pixel_width ? pixel_x - 1 : pixel_x
      py = pixel_y >= @pixel_height ? pixel_y - 1 : pixel_y

      char_col = px // 3 + 1
      char_row = py // 3 + 1
      off_col = px % 3
      off_row = py % 3

      return self unless 1 <= char_row <= @nrows && 1 <= char_col <= @ncols

      val = grid_at(char_row, char_col)
      grid_set!(char_row, char_col, val | ASCII_SIGNS_3X3[off_row][off_col])
      set_color!(char_col, char_row, color, blend)
      self
    end

    def grid_char_at(row : Int32, col : Int32) : Char
      ASCII_DECODE_512[grid_at(row, col).to_i]
    end
  end
end
