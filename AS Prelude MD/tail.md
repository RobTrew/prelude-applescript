```applescript
-- tail :: [a] -> [a]
on tail(xs)
    if xs = {} then
        missing value
    else
        rest of xs
    end if
end tailDef
```