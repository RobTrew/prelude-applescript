```applescript
-- intercalateS :: String -> [String] -> String
on intercalateS(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalateS
```