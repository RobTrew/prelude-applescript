```applescript
-- use framework "Foundation"
-- use framework "JavaScriptCore"

-- gJSC can be declared in the global namespace,
-- but unless the reference is released before the 
-- end of the script (e.g. `set gJSC to null`)
-- it will persist, and
-- Script Editor will be unable to save a .scpt file
```

```applescript
-- evalJSMay :: String -> Maybe a
```