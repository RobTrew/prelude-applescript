```applescript
-- | Build a forest from a list of seed values
```

```applescript
-- unfoldForest :: (b -> (a, [b])) -> [b] -> Forest
```

```js
// | Build a forest from a list of seed values
```

```js
// unfoldForest :: (b -> (a, [b])) -> [b] -> Forest
const unfoldForest = (f, xs) =>
    xs.map(b => unfoldTree(f, b));
```