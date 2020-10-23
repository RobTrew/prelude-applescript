```applescript
-- deleteFirst :: a -> [a] -> [a]
on deleteFirst(x, xs)
    script go
        on |λ|(xs)
            if 0 < length of xs then
                tell xs to set {h, t} to {item 1, rest}
                if x = h then
                    t
                else
                    {h} & |λ|(t)
                end if
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end deleteFirst
```