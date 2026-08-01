#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[008-JUST.KEEP.SWIMMING 009-JUST.KEEP.SWIMMING 010-JUST.KEEP.SWIMMING 011-JUST.KEEP.SWIMMING 012-JUST.KEEP.SWIMMING 013-JUST.KEEP.SWIMMING 014-JUST.KEEP.SWIMMING 015-JUST.KEEP.SWIMMING]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("dory-pep-talk")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  system "sox \"#{f[:path]}\" \"#{out}\" vol 0.95"
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.3")
result = EDITS_DIR.join("dory-pep-talk.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
