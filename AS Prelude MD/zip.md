```applescript
-- zip :: [a] -> [b] -> [(a, b)]on zip(xs, ys)    set n to min(length of xs, length of ys)        set lst to {}    repeat with i from 1 to n        set end of lst to {item i of xs, item i of ys}    end repeat    return lstend zip
```