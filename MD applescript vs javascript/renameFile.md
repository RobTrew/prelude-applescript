```applescript
-- renameFile :: FilePath -> FilePath -> IO ()
on renameFile(fp, fp2)
    set e to reference
    set {bln, obj} to current application's NSFileManager's ¬
        defaultManager's moveItemAtPath:(fp) toPath:(fp2) |error|:(e)
    if bln then
        |Right|("Renamed from: " & fp & " to " & fp2)
    else
        |Left|(obj's localizedDescription as string)
    end if
end renameFile
```


```javascript
// renamedFile :: FilePath -> FilePath -> 
// Either String IO String
const renamedFile = fp =>
    // Either a message detailing a problem, or
    // confirmation of a filename change in the OS.
    fp1 => {
        const error = $();
        return $.NSFileManager.defaultManager
            .moveItemAtPathToPathError(fp, fp1, error) ? (
                Right('Moved to: ' + fp1)
            ) : Left(ObjC.unwrap(
                error.localizedDescription
            ));
    };
```