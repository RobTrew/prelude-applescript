```applescript
-- foldlTree :: (b -> a -> b) -> b -> Tree a -> b
on foldlTree(f, acc, tree)
    script go
        property mf : mReturn(f)
        on |λ|(a, x)
            foldl(go, |λ|(a, root of x) of mf, nest of x)
        end |λ|
    end script
    |λ|(acc, tree) of go
end foldlTree
```