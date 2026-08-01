# Ruby Integer — Comparing

```ruby
1 < 2         # true
1 <= 1        # true
1 > 2         # false
1 >= 1        # true
1 == 1        # true
1 == 1.0      # true  — numeric equality
1.eql?(1.0)   # false — strict type check
1 <=> 2       # -1    — spaceship
1 <=> 1       # 0
1 <=> 0       # 1
1 <=> 'x'     # nil   — incomparable
```
