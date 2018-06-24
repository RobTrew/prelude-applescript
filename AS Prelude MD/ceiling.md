```applescript
-- ceiling :: Num -> Int
on ceiling(x)
    set nr to properFraction(x)
    set n to |1| of nr
    if (|2| of nr) > 0 then
        n + 1
    else
        n
    end if
end ceiling
```