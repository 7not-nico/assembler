# Ruby Hash — Keys

## Key equivalence

Two objects are the same key when `hash` is identical and `eql?` is true.

```ruby
a = [1, 2]
b = [1, 2]
a.hash == b.hash     # true
a.eql?(b)            # true
{[a] => 1}[b]        # 1  — same key
```

## Custom keys

Implement `hash` and `eql?` (`==`):

```ruby
class Book
  attr_reader :author, :title
  def initialize(author, title)
    @author = author; @title = title
  end
  def ==(other) = self.class === other && other.author == @author && other.title == @title
  alias eql? ==
  def hash = [self.class, @author, @title].hash
end
```

## Key modification damage

Modifying a key while in the hash breaks the index:

```ruby
a0 = [:foo, :bar]
h = {a0 => 1}
a0[0] = :bam          # mutates key
h[a0]                 # nil — index corrupted
h.rehash              # repair index
h[a0]                 # 1
```

Safe: String keys are auto-duplicated and frozen.

## compare_by_identity

Uses `object_id` instead of `hash`/`eql?`:

```ruby
h = {}.compare_by_identity
h["hello"] = 1
h["hello"] = 2        # different String object!
h.size                # 2 — identity-based
```
