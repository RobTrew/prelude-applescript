```applescript
-- showForest :: [Tree a] -> String
on showForest(xs)
    unlines(map(my showTree, xs))
end showForest
```