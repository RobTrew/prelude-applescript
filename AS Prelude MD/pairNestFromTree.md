```applescript
-- nestedListFromTree :: Tree a -> NestedList a
on nestedListFromTree(tree)
    script go
        on |λ|(x)
            {root of x, map(go, nest of x)}
        end |λ|
    end script
    |λ|(tree) of go
end pairNestFromTree
```