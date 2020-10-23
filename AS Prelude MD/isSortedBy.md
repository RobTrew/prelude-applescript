```applescript
-- isSortedBy :: (a -> a -> Bool) -> [a] -> Bool
on isSortedBy(cmp, xs)
    -- The 'isSortedBy' function returns true iff the predicate returns true
    -- for all adjacent pairs of elements in the list.
    script LE
        on |λ|(x)
            x < 1
        end |λ|
    end script
    (length of xs < 2) or all(LE, zipWith(cmp, xs, tail(xs)))
end isSortedBy
```