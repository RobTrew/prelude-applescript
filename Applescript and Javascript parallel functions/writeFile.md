```applescript
-- use framework "Foundation"
```

```applescript
-- writeFile :: FilePath -> String -> IO ()
```

```js
// writeFile :: FilePath -> String -> IO ()
const writeFile = (strPath, strText) =>
    $.NSString.alloc.initWithUTF8String(strText)
    .writeToFileAtomicallyEncodingError(
        $(strPath)
        .stringByStandardizingPath, false,
        $.NSUTF8StringEncoding, null
    );
```