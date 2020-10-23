```applescript
-- readFileLR :: FilePath -> Either String IO String
on readFileLR(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if s is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(s as string)
    end if
end readFileLR
```