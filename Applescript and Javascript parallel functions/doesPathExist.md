```applescript
-- doesPathExist :: FilePath -> IO Bool
```

```js
// doesPathExist :: FilePath -> IO Bool
const doesPathExist = strPath =>
	$.NSFileManager.defaultManager
	.fileExistsAtPath(
		$(strPath).stringByStandardizingPath
	);
```