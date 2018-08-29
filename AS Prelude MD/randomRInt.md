```applescript
-- randomRInt :: Int -> Int -> Int
on randomRInt(low, high)
    (low + ((random number) * (1 + (high - low)))) div 1
end randomRInt
```