```applescript
-- breakOnMay :: String -> String -> Maybe (String, String)
on breakOnMay(pat, src)
    -- needle -> haystack -> maybe (prefix before match, match + rest)
    if pat ≠ "" then
        set {dlm, my text item delimiters} to {my text item delimiters, pat}
        
        set lstParts to text items of src
        if length of lstParts > 1 then
            set mbTuple to Just({item 1 of lstParts, pat & ¬
                ((items 2 thru -1 of lstParts) as text)})
        else
            set mbTuple to Just({src, ""})
        end if
        
        set my text item delimiters to dlm
        return mbTuple
    else
        Nothing()
    end if
end breakOnMay
```