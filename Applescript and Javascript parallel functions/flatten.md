```applescript
-- flatten :: NestedList a -> [a]
```

```js
// flatten :: NestedList a -> [a]
const flatten = t =>
    Array.isArray(t) ? (
        [].concat.apply([], t.map(flatten))
    ): t;
```