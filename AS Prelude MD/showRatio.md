```applescript
-- showRatio :: Ratio -> String
on showRatio(r)
    set s to (n of r as string)
    set d to d of r
    if 1 ≠ d then
        s & "/" & (d as string)
    else
        s
    end if
end showRatio
```