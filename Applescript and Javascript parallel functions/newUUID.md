```applescript
-- use framework "Foundation"
```

```applescript
-- newUUID :: () -> IO UUID String
```

```js
// newUUID :: () -> IO UUID String
const newUUID = () =>
    ObjC.unwrap($.NSUUID.UUID.UUIDString);
```