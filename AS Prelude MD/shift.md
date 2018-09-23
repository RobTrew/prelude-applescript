```applescript
-- shift :: Int -> [a] -> [a]
on shift(n, xs)
    set lng to |length|(xs)
    if missing value is not lng then
        take(lng, drop(n, cycle(xs)))
    else
        drop(n, xs)
    end if
end shift
```