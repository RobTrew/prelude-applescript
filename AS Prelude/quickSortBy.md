```applescript
-- quickSortBy(comparing(my |length|), {"alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"})
```

```applescript
-- quickSortBy :: (a -> a -> Ordering) -> [a] -> [a]
on quickSortBy(cmp, xs)
    if length of xs > 1 then
        set h to item 1 of xs
        script
            on |λ|(x)
                cmp's |λ|(x, h) ≠ 1
            end |λ|
        end script
        set {less, more} to partition(result, rest of xs)
        quickSortBy(cmp, less) & h & quickSortBy(cmp, more)
    else
        xs
    end if
end quickSortBy
```