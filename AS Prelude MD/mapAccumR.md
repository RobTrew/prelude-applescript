```applescript
-- 'The mapAccumR function behaves like a combination of map and foldr; 
--  it applies a function to each element of a list, passing an accumulating 
--  parameter from |Right| to |Left|, and returning a final value of this 
--  accumulator together with the new list.' (see Hoogle)
```

```applescript
-- mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
```