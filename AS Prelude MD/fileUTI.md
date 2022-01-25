```applescript
-- fileUTI :: FilePath -> Either String String
on fileUTI(fp)
    set {uti, e} to (current application's ¬
        NSWorkspace's sharedWorkspace()'s ¬
        typeOfFile:fp |error|:(reference)) as list
        
    if uti is missing value then
        |Left|(e's localizedDescription() as text)
    else
        |Right|(uti as text)
    end if
end fileUTI
```