```applescript
-- breakOnAll :: String -> String -> [(String, String)]
on breakOnAll(pat, src)
    -- breakOnAll "/" "a/b/c/"
    -- ==> [("a", "/b/c/"), ("a/b", "/c/"), ("a/b/c", "/")]
    if "" ≠ pat then
        script
            on |λ|(a, _, i, xs)
                if 1 < i then
                    a & {{intercalate(pat, take(i - 1, xs)), ¬
                        pat & intercalate(pat, drop(i - 1, xs))}}
                else
                    a
                end if
            end |λ|
        end script
        foldl(result, {}, splitOn(pat, src))
    else
        missing value
    end if
end breakOnAll
```