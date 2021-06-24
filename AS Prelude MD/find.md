```applescript
-- find :: (a -> Bool) -> [a] -> (missing value | a)
on find(p, xs)
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return item i of xs
        end repeat
        missing value
    end tell
end find
```