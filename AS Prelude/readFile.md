```applescript
-- readFile :: FilePath -> IO String
on readFile(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if e is missing value then
        s as string
    else
        (localizedDescription of e) as string
    end if
end readFile
```