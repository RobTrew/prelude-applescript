```applescript
-- elemIndex :: Eq a => a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return Just(i)
    end repeat
    return Nothing()
end elemIndex
```