```applescript
-- takeFileName :: FilePath -> FilePath
on takeFileName(strPath)
    if strPath ≠ "" and character -1 of strPath ≠ "/" then
        item -1 of splitOn("/", strPath)
    else
        ""
    end if
end takeFileName
```