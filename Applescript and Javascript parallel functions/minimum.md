```applescript
-- minimum :: Ord a => [a] -> a
```

```js
// minimum :: Ord a => [a] -> a
const minimum = xs =>
    xs.length > 0 ? (
        foldl1((a, x) => x < a ? x : a, xs)
    ) : undefined;
```