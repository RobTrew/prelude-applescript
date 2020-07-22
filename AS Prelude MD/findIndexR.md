```applescript
-- findIndexR :: (a -> Bool) -> [a] -> Maybe Int
on findIndexR(p, xs)
    -- Just the zero-based index of the first
    -- (right-to-left match) for for the predicate p in xs, 
    -- or Nothing if no match is found.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from lng to 1 by -1
            if |λ|(item i of xs) then return Just(i - 1)
        end repeat
        return Nothing()
    end tell
end findIndexR
```