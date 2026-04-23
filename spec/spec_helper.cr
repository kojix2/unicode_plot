require "spec"
require "../src/unicode_plot"

# Strip ANSI escape codes from a string.
def strip_ansi(s : String) : String
  s.gsub(/\x1b\[[0-9;]*m/, "")
end

# Normalize output for comparison: strip trailing whitespace per line, remove trailing blank lines.
def normalize_output(s : String) : String
  lines = s.split("\n").map(&.rstrip)
  while lines.last? == ""
    lines.pop
  end
  lines.join("\n")
end

JULIA_REFS = File.join(__DIR__, "../UnicodePlots.jl/assets/references_24")

# Compare Crystal plot output against Julia's reference file (ANSI-stripped, normalized).
def test_ref(relative_path : String, plot : UnicodePlot::Plot) : Bool
  path = File.join(JULIA_REFS, relative_path)
  unless File.exists?(path)
    raise "#{relative_path}: no reference file under #{JULIA_REFS}"
  end
  julia_out = normalize_output(strip_ansi(File.read(path)))
  crystal_out = normalize_output(plot.to_s)
  crystal_out.should eq(julia_out)
  true
end
