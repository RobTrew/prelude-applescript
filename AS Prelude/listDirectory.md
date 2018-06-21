```applescript
-- listDirectory :: FilePath -> [FilePath]on listDirectory(strPath)	set ca to current application	unwrap(ca's NSFileManager's defaultManager()'s ¬		contentsOfDirectoryAtPath:(unwrap(stringByStandardizingPath of ¬			wrap(strPath))) |error|:(missing value))end listDirectory
```