```applescript
-- concatMap :: (a -> [b]) -> [a] -> [b]
```

```js
// concatMap :: (a -> [b]) -> [a] -> [b]
const concatMap = (f, xs) => [].concat.apply([], xs.map(f));
```