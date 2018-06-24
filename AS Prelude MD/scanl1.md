```applescript
-- scanl1 :: (a -> a -> a) -> [a] -> [a]
on scanl1(f, xs)
    if length of xs > 0 then
        scanl(f, item 1 of xs, tail(xs))
    else
        {}
    end if
end scanl
```