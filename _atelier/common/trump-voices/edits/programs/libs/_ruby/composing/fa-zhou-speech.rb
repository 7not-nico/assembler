#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[001-FA.ZHOU.BLOSSOM.SPEECH 002-FA.ZHOU.BLOSSOM.SPEECH 003-FA.ZHOU.BLOSSOM.SPEECH 004-FA.ZHOU.BLOSSOM.SPEECH]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("fa-zhou-speech")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  rev = 20 + i * 10
  vol = (0.7 + i * 0.1).round(2)
  system "sox \"#{f[:path]}\" \"#{out}\" reverb #{rev} vol #{vol}"
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.6")
result = EDITS_DIR.join("fa-zhou-speech.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
