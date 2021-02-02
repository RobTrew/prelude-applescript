```applescript
-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    zipWith(Tuple, xs, ys)
end zip
```