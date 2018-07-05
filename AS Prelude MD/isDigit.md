```applescript
-- isDigit :: Char -> Bool
on isDigit(c)
    set n to (id of c)
    48 ≤ n and 57 ≥ n
end isDigit
```