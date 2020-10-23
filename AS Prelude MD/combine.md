```applescript
-- combine (</>) :: FilePath -> FilePath -> FilePath
on combine(fp, fp1)
    -- The concatenation of two filePath segments,
    -- without omission or duplication of "/".
    if "" = fp or "" = fp1 then
        fp & fp1
    else if "/" = item 1 of fp1 then
        fp1
    else if "/" = item -1 of fp then
        fp & fp1
    else
        fp & "/" & fp1
    end if
end combine
```