#!/usr/bin/env ruby
require_relative "../deps/paths"
require_relative "../deps/voices"
require_relative "../deps/compose"

DEFAULT_IDS = %w[001-SHIFU.RED.PANDA 002-SHIFU.RED.PANDA 003-SHIFU.RED.PANDA 004-SHIFU.RED.PANDA 005-SHIFU.RED.PANDA 006-SHIFU.RED.PANDA]

ids = ARGV.empty? ? DEFAULT_IDS : ARGV
files = ResolveSnippets.call(ids)
abort "missing snippets" if files.length != ids.length

tmp = TmpDir.call("shifu-argument")
$stderr.puts "composing #{files.length} snippets..."

processed = files.each_with_index.map { |f, i|
  out = File.join(tmp, "#{i}.wav")
  if i == 0 || i == 5
    system "sox \"#{f[:path]}\" \"#{out}\" reverb 50 vol 0.85"
  elsif i == 4
    system "sox \"#{f[:path]}\" \"#{out}\" pitch 200 vol 1.1"
  else
    system "sox \"#{f[:path]}\" \"#{out}\" vol 0.9"
  end
  out
}

rate = SampleRate.call(processed.first)
pad = SilencePad.call(tmp, rate, "0.4")
result = EDITS_DIR.join("shifu-argument.wav").to_s
ConcatWavs.call(processed, pad, result)
$stderr.puts "playing: #{files.map { |f| f[:id] }.join(" + ")}"
system "sox \"#{result}\" -d"
system "rm -rf #{tmp}"
