```applescript
-- Applied to a predicate and a list, `all` determines if all elements 
-- of the list satisfy the predicate.
```

```applescript
-- all :: (a -> Bool) -> [a] -> Bool
```

```js
// Determines whether all elements of the structure 
// satisfy the predicate.
```

```js
// all :: (a -> Bool) -> [a] -> Bool
const all = (p, xs) => xs.every(p);
```