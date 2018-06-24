```applescript
-- dropAround :: (Char -> Bool) -> String -> String
on dropAround(p, s)
    dropWhile(p, dropWhileEnd(p, s))
end dropAround
```