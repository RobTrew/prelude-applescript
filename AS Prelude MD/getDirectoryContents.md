```applescript
-- getDirectoryContents :: FilePath -> IO [FilePath]on getDirectoryContents(strPath)	set ca to current application	(ca's NSFileManager's defaultManager()'s ¬		contentsOfDirectoryAtPath:(stringByStandardizingPath of (¬			ca's NSString's stringWithString:(strPath))) ¬			|error|:(missing value)) as listend getDirectoryContents
```