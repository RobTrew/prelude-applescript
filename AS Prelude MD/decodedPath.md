```applescript
-- use framework "Foundation"
```

```applescript
-- decodedPath :: Percent Encoded String -> FilePath
on decodedPath(fp)
    tell current application
        (its ((NSString's stringWithString:fp)'s ¬
            stringByRemovingPercentEncoding)) as string
    end tell
end decodedPath
```