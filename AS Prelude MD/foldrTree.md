```applescript
-- foldrTree :: (a -> b -> b) -> b -> Tree a -> b
on foldrTree(f, acc, tree)
    script go
        property mf : mReturn(f)
        on |λ|(x, a)
            foldr(go, |λ|(root of x, a) of mf, nest of x)
        end |λ|
    end script
    |λ|(tree, acc) of go
end foldrTree
```