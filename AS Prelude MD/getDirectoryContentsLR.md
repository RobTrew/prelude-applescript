```applescript
-- getDirectoryContentsLR :: FilePath -> Either String IO [FilePath]
on getDirectoryContentsLR(strPath)
    set ca to current application
    set {xs, e} to (ca's NSFileManager's defaultManager()'s ¬
        contentsOfDirectoryAtPath:(stringByStandardizingPath of ¬
            (ca's NSString's stringWithString:(strPath))) ¬
            |error|:(reference))
    if xs is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(xs as list)
    end if
end getDirectoryContentsLR
```