```applescript
-- flattenTree :: Tree a -> [a]
on flattenTree(node)
    -- The root elements of a tree in pre-order.
    script go
        on |λ|(x, xs)
            {root of x} & foldr(go, xs, nest of x)
        end |λ|
    end script
    go's |λ|(node, {})
end flattenTree
```