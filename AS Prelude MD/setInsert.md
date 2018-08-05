```applescript
-- setInsert :: Ord a => a -> Set a -> Set a
on setInsert(x, objcSet)
    objcSet's addObject:(x)
    objcSet
end setInsert
```