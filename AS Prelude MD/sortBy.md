```applescript
-- Enough for small scale sorts.
-- Use instead sortOn :: Ord b => (a -> b) -> [a] -> [a]
-- which is equivalent to the more flexible sortBy(comparing(f), xs)
-- and uses a much faster ObjC NSArray sort method
```

```applescript
-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
```