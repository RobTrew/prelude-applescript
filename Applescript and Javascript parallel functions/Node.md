```applescript
-- Node :: a -> [Tree a] -> Tree a
```

```js
// Node :: a -> [Tree a] -> Tree a
const Node = (v, xs) => ({
    type: 'Node',
    root: v, // any type of value (but must be consistent across tree)
    nest: xs || []
});
```