```applescript
-- enumFromThenToChar :: Char -> Char -> Char -> [Char]
on enumFromThenToChar(x1, x2, y)
    set {int1, int2, intY} to {id of x1, id of x2, id of y}
    set xs to {}
    repeat with i from int1 to intY by (int2 - int1)
        set end of xs to character id i
    end repeat
    return xs
end enumFromThenToChar
```