#!/usr/bin/env crystal
# snes9x-launcher.cr — pick and launch a ROM, functional style (Crystal port)
# Usage:
#   ./snes9x-launcher                    # letter menu: pick letter → pick ROM
#   ./snes9x-launcher 2                  # launch ROM #2 (full list order)
#   ./snes9x-launcher zelda -v0          # launch by slug fragment + filter
#   ./snes9x-launcher -l f -v9           # letter menu, then filter -v9
# Detaches snes9x (own session via setsid) — the launcher exits, the emulator stays.
#
# Port of roms/snes9x_launcher.rb (Ruby). Contract parity:
# same menu flow, same selection rules, same RUN/FAIL result lines.

ROM_DIR       = File.expand_path("../roms", __DIR__)
SNES9X        = File.expand_path("../snes9x/unix/snes9x", __DIR__)
SETSID        = "/usr/bin/setsid"
LOG           = "/tmp/opencode/snes9x-launch.log"
DEFAULT_FILTER = "-v0"

# list_roms: glob .sfc/.smc under dir, sorted basenames
def list_roms(dir : String) : Array(String)
  Dir.glob(File.join(dir, "*.{sfc,smc}")).sort.map { |p| File.basename(p) }
end

# initial_of: first letter of a slug, upcased; non-alpha buckets under '#'
def initial_of(name : String) : Char
  ch = name[0]?.try(&.upcase)
  ch && ch.ascii_letter? ? ch : '#'
end

# group_by_initial: { 'A' => [...], 'E' => [...], ... } — sorted keys
def group_by_initial(roms : Array(String)) : Hash(Char, Array(String))
  groups = roms.group_by { |r| initial_of(r) }
  ordered = Hash(Char, Array(String)).new
  groups.keys.sort.each { |k| ordered[k] = groups[k] }
  ordered
end

# print_letters: "A: 3" count lines for the letter menu
def print_letters(groups : Hash(Char, Array(String))) : Nil
  puts "ROMs in #{ROM_DIR}:"
  groups.each { |letter, roms| puts sprintf("%s: %d", letter, roms.size) }
end

# print_numbered: "%2d  name" list
def print_numbered(roms : Array(String)) : Nil
  roms.each_with_index { |r, i| puts sprintf("%2d  %s", i + 1, r) }
end

# select_rom: index pick or slug-fragment match; warns and returns nil on miss
def select_rom(roms : Array(String), arg : String) : String?
  index = arg.to_i?
  return roms[index - 1] if index && index >= 1 && index <= roms.size

  match = roms.find { |r| r.includes?(arg) }
  STDERR.puts "no ROM matches #{arg.inspect}" unless match
  match
end

# prompt: print label, read one stripped line from stdin
def prompt(label : String) : String?
  print label
  STDIN.gets.try(&.strip)
end

# pick_by_letter: letter menu loop → numbered pick → selected ROM
def pick_by_letter(groups : Hash(Char, Array(String))) : String?
  loop do
    letter = prompt("letter (A-Z, # for others, q to quit): ")
    exit 0 if letter.nil? || letter.empty? || letter.downcase == "q"
    key = letter.upcase[0]?
    key = '#' unless key && key.ascii_letter?
    roms = groups[key]?
    if roms.nil? || roms.empty?
      STDERR.puts "no ROMs under #{key}"
      next
    end
    print_numbered(roms)
    selection = prompt("pick (1-#{roms.size}): ")
    exit 0 if selection.nil? || selection.empty?
    rom = select_rom(roms, selection)
    return rom if rom
    STDERR.puts "pick again"
  end
end

# build_cmd: setsid-detached emulator argv — [setsid, snes9x, filter, rom]
def build_cmd(rom : String, filter : String) : Array(String)
  [SETSID, SNES9X, filter, File.join(ROM_DIR, rom)]
end

# launch: detach via setsid, redirect to LOG, health-check after 2 s
def launch(rom : String, filter : String) : Nil
  Dir.mkdir_p(File.dirname(LOG))
  logf = File.open(LOG, "w")
  pid = Process.new(SETSID, [SNES9X, filter, File.join(ROM_DIR, rom)], output: logf, error: logf).pid
  logf.close
  sleep 2.seconds
  if Process.exists?(pid)
    puts sprintf("RUN  pid=%d  %s %s -> %s", pid, filter, rom, LOG)
  else
    STDERR.puts "FAIL emulator exited early — see #{LOG}"
    exit 1
  end
end

# --- main dispatch ---

roms = list_roms(ROM_DIR)
if roms.empty?
  STDERR.puts "no ROMs in #{ROM_DIR}"
  exit 1
end

args = ARGV.dup
filter = DEFAULT_FILTER
filter = args.pop if args.last?.try(&.starts_with?("-"))

rom = case args.first?
      when "-l"
        pick_by_letter(group_by_initial(roms))
      when nil
        groups = group_by_initial(roms)
        print_letters(groups)
        pick_by_letter(groups)
      else
        select_rom(roms, args.first.not_nil!)
      end

if rom.nil?
  exit 1
end

puts "LAUNCH #{rom} #{filter}"
launch(rom, filter)
