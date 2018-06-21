```js
-- takeExtension :: FilePath -> Stringon takeExtension(strPath)	set xs to splitOn(".", strPath)	if length of xs > 1 then		"." & item -1 of xs	else		""	end ifend takeExtension
```