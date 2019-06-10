```applescript
-- apFn :: (a -> b -> c) -> (a -> b) -> a -> c
on apFn(f, g)
    script go
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(x, mg's |λ|(x))
        end |λ|
    end script
end apFn
```