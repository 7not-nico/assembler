# exports: TranscriptFor, ChunkWavsFor, SnippetWav, TmpDir
# purity: PURE — constants and path transformations only
# depends-on: ruby stdlib (pathname)

require "pathname"

LIB_DIR = Pathname.new(__dir__)
PROGRAMS_DIR = LIB_DIR.parent
PROJECT_DIR = LIB_DIR.join("..", "..", "..", "..", "..").realpath
CHUNKS_DIR = PROJECT_DIR.join("chunks")
EDITS_DIR = PROJECT_DIR.join("edits")
FULL_WAV = PROJECT_DIR.join("full.wav")
DB_PATH = PROJECT_DIR.join(".opencode", "voices.db")
OBJECTS_REVISED = PROJECT_DIR.join("objects-revised")

TranscriptFor = ->(video) {
  p = CHUNKS_DIR.join(video, "whisper-small", "full-transcript.json")
  File.exist?(p) ? p : nil
}

ChunkWavsFor = ->(video) {
  Dir[CHUNKS_DIR.join(video, "raw", "chunk-*.wav").to_s].sort
}

SnippetWav = ->(id) {
  dirs = Dir[OBJECTS_REVISED.join("*").to_s]
  dirs.each { |d| p = File.join(d, "#{id}.wav"); return p if File.exist?(p) }
  nil
}

TmpDir = ->(name) {
  path = "/tmp/#{name}"
  Dir.mkdir(path) unless Dir.exist?(path)
  path
}
