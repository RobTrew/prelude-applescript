```applescript
-- quickSortBy(comparing(my |length|), {"alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"})
```

```applescript
-- quickSortBy :: (a -> a -> Ordering) -> [a] -> [a]
```

```js
// Included only for comparison with AppleScript
// sort and sortBy are faster and more flexible
```

```js
// quickSortBy :: (a -> a -> Ordering) -> [a] -> [a]
const quickSortBy = (cmp, xs) =>
    xs.length > 1 ? (() => {
        const
            h = xs[0],
            lessMore = partition(
                x => cmp(x, h) !== 1,
                xs.slice(1)
            );
        return [].concat.apply(
            [], [quickSortBy(cmp, lessMore[0]), h, quickSortBy(cmp, lessMore[1])]
        );
    })() : xs;
```