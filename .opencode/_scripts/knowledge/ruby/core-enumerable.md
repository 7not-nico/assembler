# Ruby Enumerable

Mixin providing collection methods. Include `Enumerable` and define `#each` to get ~60 methods.

## Classes that include Enumerable

`Array`, `Hash`, `Range`, `Set`, `Enumerator`, `IO`, `Dir`, `Struct`, `Enumerator::Lazy`, `Enumerator::ArithmeticSequence`

## Minimal include

```ruby
class MyCollection
  include Enumerable
  def each
    yield 1; yield 2; yield 3
  end
end
```

## Enumerator

Created when no block given — enables lazy chaining:

```ruby
[1, 2, 3].map          # #<Enumerator>
[1, 2, 3].each         # #<Enumerator>
[1, 2, 3].select       # #<Enumerator>
```

## Official Docs

<https://docs.ruby-lang.org/en/3.4/Enumerable.html>
