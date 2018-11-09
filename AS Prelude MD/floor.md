```applescript
-- floor :: Num -> Int
on floor(x)
    if class of x is record then
        set nr to properFracRatio(x)
    else
        set nr to properFraction(x)
    end if
    set n to fst(nr)
    if 0 > snd(nr) then
        n - 1
    else
        n
    end if
end floor
```