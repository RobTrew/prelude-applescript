```applescript
-- chop :: ([a] -> (b, [a])) -> [a] -> [b]
on chop(f, xs)
    script go
        property g : mReturn(f)
        on |λ|(xs)
            if 0 < length of xs then
                set {b, ys} to g's |λ|(xs)
                {b} & |λ|(ys)
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end chop
```