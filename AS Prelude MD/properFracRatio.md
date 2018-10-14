```applescript
-- properFracRatio :: Ratio -> (Int, Ratio)
on properFracRatio(r)
    set n to n of r
    set d to d of r
    Tuple(n div d, ratio(n mod d, d))
end properFracRatio
```