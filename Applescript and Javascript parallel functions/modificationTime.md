```applescript
-- modificationTime :: FilePath -> Either String Date
```

```js
// modificationTime :: FilePath -> Either String Date
const modificationTime = fp =>
    bindLR(
       fileStatus(fp),
       dct => Right(ObjC.unwrap(dct.NSFileModificationDate))
    );
```