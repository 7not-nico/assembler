# exports: SampleRate, SilencePad, CutSegment, ConcatWavs, ComposeAndPlay
# purity: LOCAL-WRITE + SGNL — creates files, plays audio
# depends-on: sox, ffmpeg, ./paths

require_relative "paths"

SampleRate = ->(wav_path) {
  `soxi -r "#{wav_path}"`.strip
}

SilencePad = ->(tmp_dir, rate, duration = "0.4") {
  path = File.join(tmp_dir, "pad.wav")
  system "sox -n -r #{rate} -c 2 \"#{path}\" trim 0 #{duration}"
  path
}

CutSegment = ->(source, start_sec, end_sec, output) {
  system "ffmpeg -y -i \"#{source}\" -ss #{start_sec} -to #{end_sec} -c copy \"#{output}\" 2>/dev/null"
}

ConcatWavs = ->(wavs, pad_path, output) {
  args = ["sox"]
  wavs.each_with_index { |w, i| args << pad_path if i > 0; args << w }
  args << output
  system(*args)
}

ComposeAndPlay = ->(wavs, name) {
  return if wavs.empty?

  rate = SampleRate.call(wavs.first)
  tmp = TmpDir.call("compose")
  pad = SilencePad.call(tmp, rate)

  Dir.mkdir(EDITS_DIR.to_s) unless Dir.exist?(EDITS_DIR.to_s)
  result = EDITS_DIR.join("#{name}.wav").to_s

  ConcatWavs.call(wavs, pad, result)
  $stderr.puts "saved: #{result}"
  system "sox \"#{result}\" -d"
}
