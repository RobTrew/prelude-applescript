```applescript
-- foldTree :: (a -> [b] -> b) -> Tree a -> b
on foldTree(f, tree)
    script go
        property g : mReturn(f)'s |λ|
        on |λ|(oNode)
            g(root of oNode, map(go, nest of oNode))
        end |λ|
    end script
    |λ|(tree) of go
end foldTree
```