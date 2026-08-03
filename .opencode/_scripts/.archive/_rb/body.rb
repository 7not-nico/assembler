# exports: ExtractCatSection
# ring: 0 (PURE)

ExtractCatSection = ->(text) {
  in_maxim = false
  cat_started = false
  cat_ended = false
  lines = []

  text.each_line do |line|
    if line =~ /^\*\*[^*]+\*\*\s*[—–-]/
      in_maxim = true
      next
    end
    next unless in_maxim

    if line =~ /^## /
      if cat_started
        cat_ended = true
        break
      end
      cat_started = true
      next
    end

    if cat_started && !cat_ended
      stripped = line.strip
      next if stripped.empty?
      lines << stripped
    end
  end

  lines
}
