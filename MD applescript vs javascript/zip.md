```applescript
-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    zipWith(Tuple, xs, ys)
end zip
```


```javascript
// zip :: [a] -> [b] -> [(a, b)]
const zip = xs => ys =>
    // Use of `take` and `length` here allows for 
    // zipping with non-finite lists - i.e. generators 
    // like cycle, repeat, iterate.
    Array.from({
        length: Math.min(xs.length, ys.length)
    }, (_, i) => Tuple(xs[i])(ys[i]));
```