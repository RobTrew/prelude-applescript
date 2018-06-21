```applescript
-- intercalate :: [a] -> [[a]] -> [a]-- intercalate :: String -> [String] -> Stringon intercalate(sep, xs)  concat(intersperse(sep, xs))end intercalate
```