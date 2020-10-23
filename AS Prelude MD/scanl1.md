```applescript
-- scanl1 :: (a -> a -> a) -> [a] -> [a]
on scanl1(f, xs)
    if 0 < length of xs then
        scanl(f, item 1 of xs, rest of xs)
    else
        {}
    end if
end scanl
```