```applescript
-- sqrtLR :: Num -> Either String Num
on sqrtLR(n)
    if 0 ≤ n then
        |Right|(n ^ (1 / 2))
    else
        |Left|("Square root of negative number: " & n)
    end if
end sqrtLR
```