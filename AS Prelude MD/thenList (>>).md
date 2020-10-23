```applescript
-- thenList (>>) :: [a] -> [b] -> [b]
on thenList(xs, ys)
    script
        on |λ|(_)
            ys
        end |λ|
    end script
    concatMap(result, xs)
end thenList
```