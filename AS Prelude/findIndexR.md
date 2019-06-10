```applescript
-- findIndexR :: (a -> Bool) -> [a] -> Maybe Int
on findIndexR(f, xs)
    tell mReturn(f)
        set lng to length of xs
        repeat with i from lng to 1 by -1
            if |λ|(item i of xs) then return Just(i)
        end repeat
        return Nothing()
    end tell
end findIndexR
```