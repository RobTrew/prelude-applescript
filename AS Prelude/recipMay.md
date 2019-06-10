```applescript
-- recipMay :: Num -> Maybe Num
on recipMay(n)
    if n ≠ 0 then
        Just(1 / n)
    else
        Nothing()
    end if
end recipMay
```