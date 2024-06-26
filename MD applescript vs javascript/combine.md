```javascript
// combine (</>) :: FilePath -> FilePath -> FilePath
const combine = fp =>
    // The concatenation of two filePath segments,
    // without omission or duplication of "/".
    fp1 => Boolean(fp) && Boolean(fp1)
        ? "/" === fp1.slice(0, 1)
            ? fp1
            : "/" === fp.slice(-1)
                ? fp + fp1
                : `${fp}/${fp1}`
        : (fp + fp1);
```


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