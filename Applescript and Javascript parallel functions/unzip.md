```applescript
-- unzip :: [(a,b)] -> ([a],[b])
```

```js
// unzip :: [(a,b)] -> ([a],[b])
const unzip = xys =>
    xys.reduce(
        (a, x) => Tuple.apply(null, [0, 1].map(
            i => a[i].concat(x[i])
        )),
        Tuple([], [])
    );
```