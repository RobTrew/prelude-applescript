```applescript
-- liftMmay :: (a -> b) -> (Maybe a -> Maybe b)
```

```js
// liftMmay :: (a -> b) -> (Maybe a -> Maybe b)
const liftMmay = f =>
    mb => mb.Nothing ? mb : {
        Nothing: false,
        Just: f(mb.Just)
    };
```