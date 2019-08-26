```applescript
-- Ordering :: ( LT | EQ | GT ) | ( -1 | 0 | 1 )
```

```applescript
-- mappendOrd (<>) :: Ordering -> Ordering -> Ordering
on mappendOrd(a, b)
    if 0 ≠ a then
        a
    else
        b
    end if
end mappendOrd
```