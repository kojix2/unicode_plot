module UnicodePlot
  abstract class GraphicsArea
    abstract def nrows : Int32
    abstract def ncols : Int32
    abstract def visible? : Bool
    abstract def blank : Char

    # Preprocessing hook (returns cleanup proc). Override in subclasses that need it.
    def preprocess(io : IO) : GraphicsArea ->
      ->(_c : GraphicsArea) { }
    end

    # Print a single row. Implementations add ANSI color via use_color.
    abstract def print_row(io : IO, row : Int32, use_color : Bool) : Nil

    def to_s(io : IO) : Nil
      use_color = io.is_a?(IO::FileDescriptor) && io.as(IO::FileDescriptor).tty?
      bd = BORDER_SOLID
      bc = UnicodePlot.ansi_color(UnicodePlot.border_color)

      write_colored_border(io, use_color, bc) do
        io << bd.tl << bd.t.to_s * ncols << bd.tr
      end
      io << '\n'

      postprocess = preprocess(io)
      (1..nrows).each do |row|
        write_colored_border(io, use_color, bc) { io << bd.l }
        print_row(io, row, use_color)
        write_colored_border(io, use_color, bc) { io << bd.r }
        io << '\n' if row < nrows
      end
      postprocess.call(self)

      io << '\n'
      write_colored_border(io, use_color, bc) do
        io << bd.bl << bd.b.to_s * ncols << bd.br
      end
    end

    private def write_colored_border(io : IO, use_color : Bool, border_color : UInt32, & : ->) : Nil
      io << UnicodePlot.ansi_fg_escape(border_color) if use_color
      yield
      io << ANSI_RESET if use_color
    end
  end
end
