```applescript
-- nub :: [a] -> [a]
on nub(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@distinctUnionOfObjects.self") as list
end nub
```