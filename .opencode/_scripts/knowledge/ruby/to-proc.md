# Ruby `to_proc` Conversion Protocol

The `&` operator calls `to_proc` on any object to convert it into a block.

```ruby
object &method_name
# equivalent to: method_block = object.to_proc; some_method(&method_block)
```

## Built-in implementations

### Symbol#to_proc

```ruby
:to_s.to_proc.call(1)   # "1"
[1, 2].map(&:to_s)      # ["1", "2"]

%w[apple banana].map(&:upcase)
# ["APPLE", "BANANA"]
```

### Method#to_proc

```ruby
method(:puts).to_proc.call(1)  # prints 1
[1, 2].each(&method(:puts))    # prints 1, 2
```

### Hash#to_proc

```ruby
{test: 1}.to_proc.call(:test)  # 1
%i[test many keys].map(&{test: 1})
# [1, nil, nil]
```

## Custom to_proc

Any class can implement `to_proc`:

```ruby
class Greeter
  def initialize(greeting)
    @greeting = greeting
  end
  def to_proc
    proc { |name| "#{@greeting}, #{name}!" }
  end
end

hi = Greeter.new("Hi")
["Bob", "Jane"].map(&hi)
# ["Hi, Bob!", "Hi, Jane!"]
```
