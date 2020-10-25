```applescript
-- permutationsWithRepetition :: Int -> [a] -> [[a]]
on permutationsWithRepetition(n, xs)
    if 0 < length of xs then
        foldl1(curry(my cartesianProduct)'s |λ|(xs), replicate(n, xs))
    else
        {}
    end if
end permutationsWithRepetition
```