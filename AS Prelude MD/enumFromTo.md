```applescript
-- enumFromTo :: Int -> Int -> [Int]on enumFromTo(m, n)    if m ≤ n then        set xs to {}        repeat with i from m to n            set end of xs to i        end repeat        xs    else        {}    end ifend enumFromTo
```