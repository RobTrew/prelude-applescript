```applescript
-- allSame :: [a] -> Bool
on allSame(xs)
    if 2 > length of xs then
        true
    else
        script p
            property h : item 1 of xs
            on |λ|(x)
                h = x
            end |λ|
        end script
        all(p, rest of xs)
    end if
end allSame
```