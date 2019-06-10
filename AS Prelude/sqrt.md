```applescript
-- sqrt :: Num -> Num
on sqrt(n)
    if n ≥ 0 then
        n ^ (1 / 2)
    else
        missing value
    end if
end sqrt
```