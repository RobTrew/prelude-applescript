```applescript
-- safeMay :: (a -> Bool) -> (a -> b) -> Maybe b
```

```js
// safeMay :: (a -> Bool) -> (a -> b) -> Maybe b
const safeMay = (p, f, x) =>
    p(x) ? Just(f(x)) : Nothing();
```