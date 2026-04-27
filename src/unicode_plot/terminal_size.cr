module UnicodePlot
  module TerminalSize
    extend self

    DEFAULT_HEIGHT = 24
    DEFAULT_WIDTH  = 80

    {% if flag?(:linux) %}
      TIOCGWINSZ = 0x5413_u64
    {% elsif flag?(:darwin) || flag?(:freebsd) %}
      TIOCGWINSZ = 0x40087468_u64
    {% end %}

    {% if flag?(:linux) || flag?(:darwin) || flag?(:freebsd) %}
      lib LibTerminalSize
        struct Winsize
          ws_row : UInt16
          ws_col : UInt16
          ws_xpixel : UInt16
          ws_ypixel : UInt16
        end

        fun ioctl(fd : Int32, request : ULong, ...) : Int32
      end
    {% end %}

    def displaysize : {Int32, Int32}
      env_size || {DEFAULT_HEIGHT, DEFAULT_WIDTH}
    end

    def displaysize(io : IO) : {Int32, Int32}
      tty_size(io) || displaysize
    end

    private def env_size : {Int32, Int32}?
      rows = positive_env_int("LINES")
      cols = positive_env_int("COLUMNS")
      return {rows, cols} if rows && cols
    end

    private def positive_env_int(name : String) : Int32?
      value = ENV[name]?.try(&.to_i?)
      return unless value
      return unless value > 0
      value
    end

    private def tty_size(io : IO) : {Int32, Int32}?
      {% if flag?(:linux) || flag?(:darwin) || flag?(:freebsd) %}
        fdio = io.as?(IO::FileDescriptor)
        return nil unless fdio
        return nil unless fdio.tty?

        size_from_fd(fdio.fd)
      {% else %}
        nil
      {% end %}
    rescue
      nil
    end

    {% if flag?(:linux) || flag?(:darwin) || flag?(:freebsd) %}
      private def size_from_fd(fd : Int32) : {Int32, Int32}?
        ws = LibTerminalSize::Winsize.new
        rc = LibTerminalSize.ioctl(fd, TIOCGWINSZ, pointerof(ws))
        return nil unless rc == 0
        return nil if ws.ws_row == 0 || ws.ws_col == 0

        {ws.ws_row.to_i32, ws.ws_col.to_i32}
      rescue
        nil
      end
    {% end %}
  end
end
