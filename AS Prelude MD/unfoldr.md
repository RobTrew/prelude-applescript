```applescript
-- > unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [10,9,8,7,6,5,4,3,2,1] 
```

```applescript
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
```