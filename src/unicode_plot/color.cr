module UnicodePlot
  ANSI_RESET = "\e[0m"

  def r32(r : UInt32) : UInt32
    (r & 0x00_ff_ff_ff_u32) << 16
  end

  def g32(g : UInt32) : UInt32
    (g & 0x00_ff_ff_ff_u32) << 8
  end

  def b32(b : UInt32) : UInt32
    b & 0x00_ff_ff_ff_u32
  end

  def red(c : UInt32) : UInt8
    ((c >> 16) & 0xff_u32).to_u8
  end

  def grn(c : UInt32) : UInt8
    ((c >> 8) & 0xff_u32).to_u8
  end

  def blu(c : UInt32) : UInt8
    (c & 0xff_u32).to_u8
  end

  # Convert a color symbol/int/tuple to internal ColorType (UInt32)
  def ansi_color(color : Symbol) : UInt32
    return INVALID_COLOR if color == :normal || color == :default || color == :nothing || color == :auto
    if idx = NAMED_COLORS[color]?
      THRESHOLD + idx
    else
      INVALID_COLOR
    end
  end

  def ansi_color(color : Int32) : UInt32
    (color >= 0 && color <= 255) ? THRESHOLD + color.to_u32 : INVALID_COLOR
  end

  def ansi_color(color : UInt32) : UInt32
    color # already in internal format
  end

  def ansi_color(color : Nil) : UInt32
    INVALID_COLOR
  end

  def ansi_color(r : Int32, g : Int32, b : Int32) : UInt32
    r32(r.to_u32) + g32(g.to_u32) + b32(b.to_u32)
  end

  def ansi_color(rgb : {Int32, Int32, Int32}) : UInt32
    ansi_color(rgb[0], rgb[1], rgb[2])
  end

  # Normalize a user-facing plot color input to internal UInt32 color.
  def plot_color(color : Symbol) : UInt32
    ansi_color(color)
  end

  def plot_color(color : UInt32) : UInt32
    color
  end

  def plot_color(color : Tuple(Int32, Int32, Int32)) : UInt32
    ansi_color(color)
  end

  def plot_color(color : Nil) : UInt32
    INVALID_COLOR
  end

  # Blend two ColorType values
  def blend_colors(a : UInt32, b : UInt32) : UInt32
    return a if a == b
    if a < THRESHOLD && b < THRESHOLD # both 24-bit
      # geometric mean (RMS)
      r = Math.sqrt((red(a).to_u32**2 + red(b).to_u32**2) / 2.0).floor.to_u32
      g = Math.sqrt((grn(a).to_u32**2 + grn(b).to_u32**2) / 2.0).floor.to_u32
      bl = Math.sqrt((blu(a).to_u32**2 + blu(b).to_u32**2) / 2.0).floor.to_u32
      r32(r) + g32(g) + b32(bl)
    elsif a >= THRESHOLD && a < INVALID_COLOR && b >= THRESHOLD && b < INVALID_COLOR # both 8-bit
      THRESHOLD + ((a - THRESHOLD).to_u8 | (b - THRESHOLD).to_u8).to_u32
    elsif a != INVALID_COLOR && b != INVALID_COLOR
      Math.max(a, b)
    else
      INVALID_COLOR
    end
  end

  def complement(color : UInt32) : UInt32
    return INVALID_COLOR if color == INVALID_COLOR
    if color < THRESHOLD # 24-bit
      r32((~red(color)).to_u32) + g32((~grn(color)).to_u32) + b32((~blu(color)).to_u32)
    else # 8-bit
      THRESHOLD + (~(color - THRESHOLD).to_u8).to_u32
    end
  end

  def complement(color : Symbol) : UInt32
    complement(ansi_color(color))
  end

  # ANSI escape for foreground color
  def ansi_fg_escape(color : UInt32) : String
    return "" if color == INVALID_COLOR
    if color < THRESHOLD # 24-bit
      "\e[38;2;#{red(color)};#{grn(color)};#{blu(color)}m"
    else # 8-bit
      "\e[38;5;#{(color - THRESHOLD).to_u8}m"
    end
  end

  # ANSI escape for background color
  def ansi_bg_escape(color : UInt32) : String
    return "" if color == INVALID_COLOR
    if color < THRESHOLD # 24-bit
      "\e[48;2;#{red(color)};#{grn(color)};#{blu(color)}m"
    else # 8-bit
      "\e[48;5;#{(color - THRESHOLD).to_u8}m"
    end
  end

  # Print text with foreground color to io
  def print_color(io : IO, color : UInt32, text : String, use_color : Bool = true) : Nil
    if use_color && color != INVALID_COLOR
      io << ansi_fg_escape(color)
      io << text
      io << ANSI_RESET
    else
      io << text
    end
  end

  def print_color(io : IO, color : UInt32, text : String, use_color : Bool, bgcol : UInt32) : Nil
    if use_color
      io << ansi_fg_escape(color) unless color == INVALID_COLOR
      io << ansi_bg_escape(bgcol) unless bgcol == INVALID_COLOR
      io << text
      io << ANSI_RESET
    else
      io << text
    end
  end

  def print_color(io : IO, color : Symbol, text : String, use_color : Bool = true) : Nil
    print_color(io, ansi_color(color), text, use_color)
  end
end
