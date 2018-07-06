```applescript
-- readLR :: Read a => String -> Either String a
on readLR(s)
    try
        |Right|(run script s)
    on error e
        |Left|(e)
    end try
end readLR
```