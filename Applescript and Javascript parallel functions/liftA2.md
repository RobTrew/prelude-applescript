```applescript
-- Lift a binary function to actions.
-- e.g.
-- liftA2(mult, {1, 2, 3}, {4, 5, 6}) 
--> {4, 5, 6, 8, 10, 12, 12, 15, 18}
```

```applescript
-- liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
```

```js
// Lift a binary function to actions.
// liftA2 f a b = fmap f a <*> b
```

```js
// liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
const liftA2 = (f, a, b) =>
    Array.isArray(a) ? (
        liftA2List(f, a, b)
    ) : (t => Boolean(t) ? (
        t === 'Either' ? (
            liftA2LR(f, a, b)
        ) : t === 'Maybe' ? (
            liftA2Maybe(f, a, b)
        ) : t === 'Tuple' ? (
            liftA2Tuple(f, a, b)
        ) : undefined
    ) : undefined)(a.type);
```