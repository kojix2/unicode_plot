require "./spec_helper"

describe UnicodePlot::TerminalSize do
  it "prefers ENV LINES/COLUMNS for displaysize" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "31"
    ENV["COLUMNS"] = "111"

    begin
      UnicodePlot::TerminalSize.displaysize.should eq({31, 111})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end

  it "falls back to defaults when ENV is missing" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV.delete("LINES")
    ENV.delete("COLUMNS")

    begin
      UnicodePlot::TerminalSize.displaysize.should eq({24, 80})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end

  it "falls back to defaults when ENV is invalid" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "0"
    ENV["COLUMNS"] = "abc"

    begin
      UnicodePlot::TerminalSize.displaysize.should eq({24, 80})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end

  it "displaysize(io) falls back for non-tty IO" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "29"
    ENV["COLUMNS"] = "101"

    begin
      io = IO::Memory.new
      UnicodePlot::TerminalSize.displaysize(io).should eq({29, 101})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end
end

describe UnicodePlot do
  it "out_stream_size without io uses TerminalSize.displaysize" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "27"
    ENV["COLUMNS"] = "99"

    begin
      UnicodePlot.out_stream_size.should eq({27, 99})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end

  it "out_stream_height/width derive from out_stream_size" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "26"
    ENV["COLUMNS"] = "98"

    begin
      UnicodePlot.out_stream_height.should eq(26)
      UnicodePlot.out_stream_width.should eq(98)
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end

  it "out_stream_size(io) uses io overload and falls back" do
    old_lines = ENV["LINES"]?
    old_columns = ENV["COLUMNS"]?

    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "97"

    begin
      io = IO::Memory.new
      UnicodePlot.out_stream_size(io).should eq({25, 97})
    ensure
      if old_lines
        ENV["LINES"] = old_lines
      else
        ENV.delete("LINES")
      end
      if old_columns
        ENV["COLUMNS"] = old_columns
      else
        ENV.delete("COLUMNS")
      end
    end
  end
end
