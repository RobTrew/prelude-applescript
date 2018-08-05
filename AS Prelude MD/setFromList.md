```applescript
-- setFromList :: Ord a => [a] -> Set a
on setFromList(xs)
    set ca to current application
    ca's NSMutableSet's ¬
        setWithArray:(ca's NSArray's arrayWithArray:(xs))
end setFromList
```