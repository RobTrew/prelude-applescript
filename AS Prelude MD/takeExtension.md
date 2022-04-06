```applescript
-- takeExtension :: FilePath -> String
on takeExtension(fp)
    set xs to splitOn(".", fp)
    if 1 < length of xs then
        "." & item -1 of xs
    else
        ""
    end if
end takeExtension
```