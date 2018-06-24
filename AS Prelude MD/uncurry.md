```applescript
-- Returns a function on a single tuple (containing 2 arguments)
-- derived from an equivalent function with 2 distinct arguments
```

```applescript
-- uncurry :: (a -> b -> c) -> ((a, b) -> c)
on uncurry(f)
    script
        property mf : mReturn(f)'s |λ|
        on |λ|(pair)
            mf(|1| of pair, |2| of pair)
        end |λ|
    end script
end uncurry
```