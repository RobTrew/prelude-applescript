```applescript
-- renamedFile :: FilePath -> FilePath ->
-- Either IO String IO String
on renamedFile(fp, fp2)
    set e to reference
    set {bln, obj} to current application's NSFileManager's ¬
        defaultManager's moveItemAtPath:(fp) toPath:(fp2) |error|:(e)
    if bln then
        |Right|(fp2)
    else
        |Left|(obj's localizedDescription as string)
    end if
end renameFile
```