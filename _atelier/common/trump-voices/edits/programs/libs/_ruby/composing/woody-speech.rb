#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[001-YOU.ARE.A.TOY 002-YOU.ARE.A.TOY 003-YOU.ARE.A.TOY 004-YOU.ARE.A.TOY 005-YOU.ARE.A.TOY 006-YOU.ARE.A.TOY 007-YOU.ARE.A.TOY]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("woody-speech")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  vol = (1.0 - i * 0.06).round(2)
  system "sox \"#{f[:path]}\" \"#{out}\" vol #{vol}"
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.3")
result = EDITS_DIR.join("woody-speech.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
