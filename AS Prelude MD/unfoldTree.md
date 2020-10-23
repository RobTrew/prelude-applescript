```applescript
-- | Build a tree from a seed value
-- unfoldTree :: (b -> (a, [b])) -> b -> Tree a
on unfoldTree(f, b)
    set g to mReturn(f)
    set tpl to g's |λ|(b)
    Node(|1| of tpl, unfoldForest(g, |2| of tpl))
end unfoldTree
```