```applescript
-- table :: Int -> [String] -> Stringon table(n, xs)    -- A list of strings formatted as    -- right-justified rows of n columns.    set w to length of last item of xs    unlines(map(my unwords, ¬        chunksOf(n, map(justifyRight(w, space), xs))))end table
```