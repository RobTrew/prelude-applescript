```applescript
-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(p, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs)) 
    script go
        property f : mReturn(p)
        on |λ|(cs)
            if {} ≠ cs then
                set c to item 1 of cs
                if |λ|(c) of p then
                    set {ys, zs} to go's |λ|(rest of cs)
                    {{c} & ys, zs}
                else
                    {{}, cs}
                end if
            else
                {}
            end if
        end |λ|
    end script
    |λ|(xs) of go
end span
```