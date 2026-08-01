# Calculator — subject ← action(subject, object)

OPS = {
  "+" => ->(a, b) { a + b },
  "-" => ->(a, b) { a - b },
  "*" => ->(a, b) { a * b },
  "/" => ->(a, b) { a / b },
  "**" => ->(a, b) { a**b }
}.freeze


def get_object(prompt)
  loop do
    print prompt
    input = $stdin.gets or return nil
    input = input.strip
    return nil if %w[exit quit q].include?(input)
    num = Integer(input) rescue nil
    return num if num&.>= 0
    puts "  enter a natural number (0, 1, 2, ...)"
  end
end


def get_action
  loop do
    print "  action? (+ - * / **) "
    input = $stdin.gets or return nil
    input = input.strip
    return nil if %w[exit quit q].include?(input)
    return input if OPS[input]
    puts "  choose: +  -  *  /  **"
  end
end


def run
  puts "  calculator — subject ← action(subject, object)"
  puts "  exit / q to quit\n\n"

  subject = get_object("  subject? ")

  loop do
    break if subject.nil?

    action = get_action
    break if action.nil?

    object = get_object("  object? ")
    break if object.nil?

    raise ZeroDivisionError if action == "/" && object == 0

    subject = OPS[action].call(subject, object)
    subject = subject.to_i if subject == subject.to_i
    puts "  = #{subject}\n\n"
  end
end


if __FILE__ == $PROGRAM_NAME
  run
end
