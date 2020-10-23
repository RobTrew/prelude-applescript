```applescript
-- foldl1 :: (a -> a -> a) -> [a] -> a
on foldl1(f, xs)
    if length of xs > 1 then
        tell mReturn(f)
            set v to {item 1 of xs}
            set lng to length of xs
            repeat with i from 2 to lng
                set v to |λ|(v, item i of xs, i, xs)
            end repeat
            return v
        end tell
    else
        item 1 of xs
    end if
end foldl1
```