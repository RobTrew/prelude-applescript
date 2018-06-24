```applescript
-- randomRInt :: Int -> Int -> Int
on randomRInt(low, high)
    floor(low + ((random number) * (1 + (high - low))))
end randomRInt
```