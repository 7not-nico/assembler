# Polish notation calculator — action → object → subject convention
#
#   action  : operator (+ or -)
#   object  : operand entered one at a time
#   subject : running total (result)
#
# Usage:
#   ruby polish-calc.rb

OPS = {
  "+" => ->(a, b) { a + b },
  "-" => ->(a, b) { a - b }
}.freeze


def get_action
  loop do
    print "  action? (+ -) "
    line = $stdin.gets
    return nil unless line
    line = line.strip
    return nil if %w[exit quit q].include?(line)
    return line if OPS[line]
    puts "  choose + or -"
  end
end


def get_operands(action)
  subject = nil
  i = 1

  loop do
    print "  operand #{i}: "
    line = $stdin.gets
    break unless line
    line = line.strip
    break if line.empty?

    object = Integer(line) rescue nil
    unless object
      puts "  enter a number"
      next
    end

    if subject.nil?
      subject = object
    else
      subject = OPS[action].call(subject, object)
    end

    i += 1
  end

  subject
end


def run
  puts "  polish calculator — action → object → subject"
  puts "  q to quit\n\n"

  loop do
    action = get_action
    break unless action

    result = get_operands(action)

    if result.nil?
      puts "  no operands entered"
    else
      puts "  = #{result}\n\n"
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  run
end
