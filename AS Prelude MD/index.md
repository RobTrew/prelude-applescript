```applescript
-- index (!!) :: [a] -> Int -> Maybe a
-- index (!!) :: String -> Int -> Maybe Char
on |index|(xs, i)
    if script is class of xs then
      -- not yet defined for generators
      -- missing value
    else
        if length of xs < i then
            Nothing()
        else
            Just(item i of xs)
        end if
    end if
end |index|
```