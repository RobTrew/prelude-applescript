```applescript
-- orderedUnion :: [a] -> [a] -> [a]on orderedUnion(xs, ys)    (union(setFromList(xs), setFromList(ys))'s ¬        allObjects()'s sortedArrayUsingSelector:"compare:") as listend orderedUnion
```