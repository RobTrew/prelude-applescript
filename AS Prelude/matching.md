```applescript
-- Returns a sequence-matching function for findIndices etc
```

```applescript
-- matching :: [a] -> (a -> Int -> [a] -> Bool)
-- matching :: String -> (Char -> Int -> String -> Bool)
on matching(pat)
    if class of pat is text then
        set xs to characters of pat
    else
        set xs to pat
    end if
    set lng to length of xs
    set bln to 0 < lng
    if bln then
        set h to item 1 of xs
    else
        set h to missing value
    end if
    script
        on |λ|(x, i, src)
            (h = x) and xs = ¬
                (items i thru min(length of src, -1 + lng + i) of src)
        end |λ|
    end script
end matching
```