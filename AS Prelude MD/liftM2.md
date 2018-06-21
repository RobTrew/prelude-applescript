```applescript
--  liftM2 (+) [0,1] [0,2] = [0,2,1,3]
```

```applescript
-- liftM2 :: (a -> b -> c) -> [a] -> [b] -> [c]on liftM2(f, a, b)	ap(map(curry(f), a), b)end liftM2
```