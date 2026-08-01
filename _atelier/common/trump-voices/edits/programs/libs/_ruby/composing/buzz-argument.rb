#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[001-BUZZ.ALIEN 005-BUZZ.ALIEN 006-BUZZ.ALIEN 007-BUZZ.ALIEN 008-BUZZ.ALIEN 009-BUZZ.ALIEN 010-BUZZ.ALIEN]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("buzz-argument")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  if i < 2
    system "sox \"#{f[:path]}\" \"#{out}\" pitch -300 reverb 30 vol 0.85"
  else
    system "sox \"#{f[:path]}\" \"#{out}\" pitch 500 echo 0.8 0.7 25 0.25 vol 0.9"
  end
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.4")
result = EDITS_DIR.join("buzz-argument.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
