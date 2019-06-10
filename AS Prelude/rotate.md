```applescript
-- rotate :: Int -> [a] -> [a]
on rotate(n, xs)
    set lng to |length|(xs)
    if missing value is not lng then
        take(lng, drop(lng - n, cycle(xs)))
    else
        lng
    end if
end rotate
```