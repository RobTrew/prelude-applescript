```applescript
-- Lift a binary function to actions.
-- e.g.
-- liftA2(mult, {1, 2, 3}, {4, 5, 6}) 
--> {4, 5, 6, 8, 10, 12, 12, 15, 18}
```

```applescript
-- liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
```