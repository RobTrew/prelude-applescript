```applescript
-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of acc to (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
```