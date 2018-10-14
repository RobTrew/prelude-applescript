```applescript
-- ratio :: Int -> Int -> Ratio Int
on ratio(n, d)
    if 0 ≠ d then
        set g to gcd(n, d)
        {type:"Ratio", n:(n div g), d:(d div g)}
    else
        missing value
    end if
end ratio
```