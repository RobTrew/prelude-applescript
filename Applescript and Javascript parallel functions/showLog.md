```applescript
-- showLog :: a -> IO ()
```

```js
// showLog :: a -> IO ()
const showLog = (...args) =>
    console.log(
        args
        .map(JSON.stringify)
        .join(' -> ')
    );
```