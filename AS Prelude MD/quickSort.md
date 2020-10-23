```applescript
-- quickSort :: (Ord a) => [a] -> [a]
on quickSort(xs)
    -- Adequate for small sorts, but sort (Ord a => [a] -> [a]), (which uses the ObjC
    -- sortedArrayUsingSelector) is the one to use
    if length of xs > 1 then
        set h to item 1 of xs
        script
            on |λ|(x)
                x ≤ h
            end |λ|
        end script
        set {less, more} to partition(result, rest of xs)
        quickSort(less) & h & quickSort(more)
    else
        xs
    end if
end quickSort
```