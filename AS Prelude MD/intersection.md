```applescript
-- intersection :: Ord a => Set a -> Set a -> Set a
on intersection(a, b)
    set s to current application's NSMutableSet's alloc's init()
    s's setSet:(a)
    s's intersectSet:(b)
    return s
end intersection
```