# exports: TimeBlock, FormatDuration
# ring: 0 (PURE)

FormatDuration = ->(secs) {
  if secs < 1.0
    "#{(secs * 1000).round(0)}ms"
  elsif secs < 60.0
    "#{secs.round(2)}s"
  else
    m = (secs / 60).to_i
    s = (secs % 60).round(1)
    "#{m}m #{s}s"
  end
}

TimeBlock = ->(label, block) {
  start = Time.now
  result = block.call
  elapsed = Time.now - start
  $stderr.puts "  [#{FormatDuration.call(elapsed)}] #{label}"
  result
}
