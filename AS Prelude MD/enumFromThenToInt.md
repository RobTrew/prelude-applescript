```applescript
-- enumFromThenToInt :: Int -> Int -> Int -> [Int]
on enumFromThenToInt(x1, x2, y)
    set xs to {}
    set d to max(1, (x2 - x1))
    repeat with i from x1 to y by d
        set end of xs to i
    end repeat
    return xs
end enumFromThenToInt
```