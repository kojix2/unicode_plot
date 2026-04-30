require "../src/unicode_plot"

include UnicodePlot

# Build as a Git plugin:
#   crystal build examples/time_axis.cr -o git-commit-plot
#   mv git-commit-plot ~/.local/bin/
# Then run:
#   git commit-plot
#   git commit-plot /path/to/repo

directory = File.expand_path(ARGV[0]? || Dir.current)
_, terminal_width = UnicodePlot.out_stream_size(STDOUT)
plot_width = Math.max(20, terminal_width - 32)

def date_from_git(value : String) : Time
  year, month, day = value.split("-").map(&.to_i)
  Time.utc(year, month, day)
end

stdout = IO::Memory.new
stderr = IO::Memory.new
status = Process.run(
  "git",
  ["-C", directory, "log", "--date=short", "--format=%ad"],
  output: stdout,
  error: stderr
)

unless status.success?
  abort "git log failed in #{directory}: #{stderr.to_s.strip}"
end

counts = Hash(Time, Int32).new(0)
stdout.to_s.each_line do |line|
  next if line.empty?
  counts[date_from_git(line)] += 1
end

abort "no commits found in #{directory}" if counts.empty?

dates = counts.keys.sort!
values = dates.map { |date| counts[date].to_f64 }

plot = stairs(
  dates,
  values,
  format: "%F",
  title: "Git commits per day",
  xlabel: "commit date",
  ylabel: "commits",
  name: "commits",
  color: :green,
  width: plot_width
)

puts plot
