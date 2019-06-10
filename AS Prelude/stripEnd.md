```applescript
-- stripEnd :: String -> String
on stripEnd(s)
    dropWhileEnd(my isSpace, s)
end stripEnd
```