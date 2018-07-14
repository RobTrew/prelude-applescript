```applescript
-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    if 0 < lng and class of (item 1 of xs) is string then
        set acc to ""
    else
        set acc to {}
    end if
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & |λ|(item i of xs, i, xs)
        end repeat
    end tell
    return acc
end concatMap
```