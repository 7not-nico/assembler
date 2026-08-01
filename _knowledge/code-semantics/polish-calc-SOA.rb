# Polish notation calculator — subject → object → action

OPS = {
  "+" => ->(a, b) { a + b },
  "-" => ->(a, b) { a - b }
}.freeze


def read_action
  loop do
    print "  action? (+ -) "
    case $stdin.gets&.strip
    when nil, /^q(uit)?$/i then return nil
    when /^[+-]$/ then return $&
    else puts "  choose + or -"
    end
  end
end


def read_operands(action)
  subject = nil

  (1..).each do |i|
    print "  operand #{i}: "
    line = $stdin.gets
    break unless line
    line = line.strip
    break if line.empty?

    object = Integer(line) rescue nil
    unless object
      puts "  enter a number"
      redo
    end

    if subject
      # subject  →  object  →  action  →  new subject
      # current acc  operand    operator    result
      action_fn = OPS[action]
      subject = action_fn.call(subject, object)
    else
      subject = object
    end
  end

  subject
end


def run
  puts "  polish calculator — subject → object → action"
  puts "  q to quit\n\n"

  loop do
    action = read_action or break
    result = read_operands(action)
    puts result ? "  = #{result}\n\n" : "  no operands entered"
  end
end


if __FILE__ == $PROGRAM_NAME
  run
end
