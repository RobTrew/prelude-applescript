```applescript
-- showPrecision :: Int -> Float -> String
on showPrecision(n, x)
    set d to 10 ^ n
    ((round (x * d)) / d) as string
end showPrecision
```