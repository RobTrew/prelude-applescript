```applescript
-- index (!!) :: [a] -> Int -> a
-- index (!!) :: String -> Int -> Char
on |index|(xs, i)
    item i of xs
end |index|
```