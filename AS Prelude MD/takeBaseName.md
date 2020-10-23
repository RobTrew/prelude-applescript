```applescript
-- takeBaseName :: FilePath -> String
on takeBaseName(strPath)
    if "" ≠ strPath then
        if "/" = text -1 of strPath then
            ""
        else
            set fn to item -1 of splitOn("/", strPath)
            if fn contains "." then
                intercalate(".", items 1 thru -2 of splitOn(".", fn))
            else
                fn
            end if
        end if
    else
        ""
    end if
end takeBaseName
```