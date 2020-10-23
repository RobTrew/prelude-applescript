```applescript
-- fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
on fTable(s, xShow, fxShow, f, xs)
    set ys to map(xShow, xs)
    set w to maximum(map(my |length|, ys))
    script arrowed
        on |λ|(a, b)
            justifyRight(w, space, a) & " -> " & b
        end |λ|
    end script
    s & linefeed & unlines(zipWith(arrowed, ¬
        ys, map(compose(fxShow, f), xs)))
end fTable
```