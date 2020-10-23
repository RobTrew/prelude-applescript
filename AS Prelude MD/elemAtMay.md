```applescript
-- If x is a Dictionary then reads the Int as an index
-- into the lexically sorted keys of the Dict, 
-- returning a Maybe (Key, Value) pair.
-- If x is a list, then return a Maybe a 
-- (In either case, returns Nothing for an Int out of range)
-- elemAtMay :: Int -> Dict -> Maybe (String, a)
-- elemAtMay :: Int -> [a] -> Maybe a
on elemAtMay(i, x)
    set bln to class of x is record
    if bln then
        set ks to keys(x)
        if i ≤ |length|(ks) then
            set k to item i of sort(ks)
            script pair
                on |λ|(v)
                    Just(Tuple(k, v))
                end |λ|
            end script
            bindMay(lookup(k, x), pair)
        end if
    else
        if i ≤ |length|(x) then
            Just(item i of x)
        else
            Nothing()
        end if
    end if
end elemAtMay
```