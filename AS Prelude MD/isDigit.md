```applescript
-- isDigit :: Char -> Bool
on isDigit(c)
    set d to (id of c) - 48 -- id of "0"
    d ≥ 0 and d ≤ 9
end isDigit
```