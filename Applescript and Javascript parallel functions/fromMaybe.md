```applescript
-- fromMaybe :: a -> Maybe a -> a
```

```js
// fromMaybe :: a -> Maybe a -> a
const fromMaybe = (def, mb) => mb.Nothing ? def : mb.Just;
```