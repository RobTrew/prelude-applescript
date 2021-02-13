```applescript
-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(p, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs)) 
    script go
        property mp : mReturn(p)
        on |λ|(vs)
            if {} ≠ vs then
                set x to item 1 of vs
                if |λ|(x) of mp then
                    set {ys, zs} to |λ|(rest of vs)
                    {{x} & ys, zs}
                else
                    {{}, vs}
                end if
            else
                {{}, {}}
            end if
        end |λ|
    end script
    |λ|(xs) of go
end span
```