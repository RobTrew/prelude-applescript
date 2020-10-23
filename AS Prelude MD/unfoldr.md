```applescript
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A list obtained from a simple value.
    -- Dual to foldr.
    -- unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
    -- -> [10,9,8,7,6,5,4,3,2,1] 
    set xr to {v, v} -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(snd(xr))
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to fst(xr)
            end if
        end repeat
    end tell
    return xs
end unfoldr
```