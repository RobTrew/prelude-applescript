```applescript
-- ordering :: () -> Ordering
on ordering()
    enumFromPairs("Ordering", {{"LT", -1}, {"EQ", 0}, {"GT", 1}})
end ordering
```