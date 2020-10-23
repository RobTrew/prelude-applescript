```applescript
-- splitFileName :: FilePath -> (String, String)
on splitFileName(strPath)
    -- Split a filename into directory and file. combine is the inverse.
    if strPath ≠ "" then
        if last character of strPath ≠ "/" then
            set xs to splitOn("/", strPath)
            set stem to init(xs)
            if stem ≠ {} then
                Tuple(intercalate("/", stem) & "/", |last|(xs))
            else
                Tuple("./", |last|(xs))
            end if
        else
            Tuple(strPath, "")
        end if
    else
        Tuple("./", "")
    end if
end splitFileName
```