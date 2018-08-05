```applescript
-- setMember :: Ord a => a -> Set a -> Bool
on setMember(x, objcSet)
    missing value is not (objcSet's member:(x))
end setMember
```