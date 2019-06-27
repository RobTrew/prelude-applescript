```applescript
-- treeFromPairNest :: PairNest a -> Tree a
on treeFromPairNest(vxs)
    script go
        on |λ|(pair)
            Node(item 1 of pair, map(go, item 2 of pair))
        end |λ|
    end script
    |λ|(vxs) of go
end treeFromPairNest
```