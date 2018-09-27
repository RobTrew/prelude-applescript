```applescript
-- showList :: [a] -> String
on showList(xs)
    "[" & intercalateS(", ", map(show, xs)) & "]"
end showList
```