```applescript
-- ceiling :: Num -> Int
on ceiling(x)
    set nr to properFraction(x)
    set n to |1| of nr
    if 0 < (|2| of nr) then
        n + 1
    else
        n
    end if
end ceiling
```