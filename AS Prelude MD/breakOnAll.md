```applescript
-- breakOnAll "::" ""
-- ==> []
-- breakOnAll "/" "a/b/c/"
-- ==> [("a", "/b/c/"), ("a/b", "/c/"), ("a/b/c", "/")]
```

```applescript
-- breakOnAll :: String -> String -> [(String, String)]
```