```applescript
-- Returns the conjunction of a Boolean 
-- list. For the result to be true, 
-- all values in the list must be true.
```

```applescript
-- and :: [Bool] -> Bool
```

```js
// | The conjunction of a container of Bools. 
// True unless any contained value is false.
```

```js
// and :: [Bool] -> Bool
const and = xs =>
    xs.every(Boolean);
```