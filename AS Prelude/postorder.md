```applescript
-- Root elements of tree flattened bottom-up
-- into a postorder list.
```

```applescript
-- postorder :: Tree a -> [a]
on postorder(node)
    script go
        on |λ|(xs, x)
            foldl(go, xs, nest of x) & {root of x}
        end |λ|
    end script
    go's |λ|({}, node)
end postorder
```