```js
-- tempFilePath :: String -> IO FilePathon tempFilePath(template)	(current application's ¬		NSTemporaryDirectory() as string) & ¬		takeBaseName(template) & ¬		text 3 thru -1 of ((random number) as string) & ¬		takeExtension(template)end tempFilePath
```