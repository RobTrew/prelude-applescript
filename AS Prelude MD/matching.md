```applescript
-- Returns a sequence-matching function for findIndices etc
```

```applescript
-- matching :: [a] -> (a -> Int -> [a] -> Bool)
on matching(pat)
    set lng to length of pat
    set bln to 0 < lng
    if bln then
        set h to item 1 of pat
    else
        set h to missing value
    end if
    script
        on |λ|(x, i, src)
            (h = x) and pat = ¬
                (items i thru min(length of src, -1 + lng + i) of src)
        end |λ|
    end script
end matching
```