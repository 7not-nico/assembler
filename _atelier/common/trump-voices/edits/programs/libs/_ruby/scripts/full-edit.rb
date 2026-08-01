#!/usr/bin/env ruby
# @toolclass TRNS
# depends-on: ./libs/paths, ./libs/compose

require_relative "../deps/loader"
require_relative "../deps/paths"
require_relative "../deps/compose"

LoadPhrases = ->(transcript_path) {
  data = JSON.parse(File.read(transcript_path))
  idx = 0
  data["segments"].flat_map { |seg|
    offset = seg["offset_sec"]
    seg["chunks"].filter_map { |ch|
      text = ch["text"].strip
      next if text.empty? || text.length < 3
      p = { id: idx, text: text, start: offset + ch["timestamp"][0], end: offset + ch["timestamp"][1] }
      idx += 1
      p
    }
  }
}

RenderPhrases = ->(phrases) {
  lines = ["full.wav: #{FULL_WAV}", "phrases:"]
  lines.concat phrases.map { |p|
    dur = (p[:end] - p[:start]).round(1)
    "  #{p[:id]}. [#{p[:start].round(1)}s - #{p[:end].round(1)}s] (#{dur}s) #{p[:text]}"
  }
  $stderr.puts lines.join("\n")
  $stderr.puts
}

CutPhrases = ->(phrases, indices) {
  tmp = TmpDir.call("full-edit")
  indices.each_with_index.filter_map { |idx, i|
    p = phrases[idx]
    next unless p
    out = File.join(tmp, "#{i}.wav")
    CutSegment.call(FULL_WAV.to_s, p[:start], p[:end], out)
    $stderr.puts "  cut: #{p[:text]}"
    out
  }
}

Run = ->(video, indices) {
  tp = TranscriptFor.call(video)
  unless tp
    $stderr.puts "error: transcript not found for #{video}"
    exit 1
  end
  unless File.exist?(FULL_WAV)
    $stderr.puts "error: full.wav not found"
    exit 1
  end

  phrases = LoadPhrases.call(tp.to_s)
  RenderPhrases.call(phrases)

  if indices.empty?
    $stderr.print "pick: "
    input = $stdin.gets&.strip
    indices = input.split.map(&:to_i) if input && !input.empty?
  end

  if indices && !indices.empty?
    wavs = CutPhrases.call(phrases, indices)
    ComposeAndPlay.call(wavs, "#{video}-full-edit")
  end
}

video = ARGV[0]
unless video
  $stderr.puts "usage: full-edit <video> [phrase-id ...]"
  exit 1
end

Run.call(video, ARGV.drop(1).map(&:to_i))
