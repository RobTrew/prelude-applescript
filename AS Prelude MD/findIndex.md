```applescript
-- findIndex :: (a -> Bool) -> [a] -> Maybe Int
on findIndex(p, xs)
    -- Just the zero-based index of the first
    -- (left-to-right match) for for the predicate p in xs, 
    -- or Nothing if no match is found.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return Just(i - 1)
        end repeat
        return Nothing()
    end tell
end findIndex
```