```applescript
-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to |length|(xs)
    if 0 = lng then
        Nothing()
    else
        if (2 ^ 29 - 1) as integer > lng then
            if class of xs is string then
                set cs to text items of xs
                Just(Tuple(item 1 of cs, rest of cs))
            else
                Just(Tuple(item 1 of xs, rest of xs))
            end if
        else
            set nxt to take(1, xs)
            if {} is nxt then
                Nothing()
            else
                Just(Tuple(item 1 of nxt, xs))
            end if
        end if
    end if
end uncons
```