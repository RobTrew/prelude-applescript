```applescript
-- > unfoldl (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [1,2,3,4,5,6,7,8,9,10]
```

```applescript
-- unfoldl :: (b -> Maybe (a, b)) -> b -> [a]
```