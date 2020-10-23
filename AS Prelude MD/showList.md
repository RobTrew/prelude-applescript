```applescript
-- showList :: [a] -> String
on showList(xs)
    "[" & intercalateS(", ", map(my show, xs)) & "]"
end showList
```