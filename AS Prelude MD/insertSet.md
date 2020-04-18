```applescript
-- insertSet :: Ord a => a -> Set a -> Set a
on insertSet(x, oSet)
    oSet's addObject:(x)
    return oSet
end insertSet
```