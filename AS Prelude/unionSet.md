```applescript
-- unionSet :: Ord a => Set a -> Set a -> Set a
on unionSet(s, s1)
    set sUnion to current application's NSMutableSet's alloc's init()
    sUnion's setSet:(s)
    sUnion's unionSet:(s1)
    return sUnion
end unionSet
```