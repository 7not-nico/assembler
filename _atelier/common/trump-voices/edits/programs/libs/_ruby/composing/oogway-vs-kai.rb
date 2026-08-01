#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[005-OOGWAY.VS.KAI 006-OOGWAY.VS.KAI 007-OOGWAY.VS.KAI 008-OOGWAY.VS.KAI 009-OOGWAY.VS.KAI 010-OOGWAY.VS.KAI 011-OOGWAY.VS.KAI 016-OOGWAY.VS.KAI]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("oogway-vs-kai")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  vol = (i.even? ? 0.9 : 1.0).round(2)
  system "sox \"#{f[:path]}\" \"#{out}\" reverb 40 vol #{vol}"
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.5")
result = EDITS_DIR.join("oogway-vs-kai.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
