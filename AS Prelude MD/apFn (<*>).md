```applescript
-- apFn :: (a -> b -> c) -> (a -> b) -> (a -> c)
on apFn(f, g)
    script go
        property mf : |λ| of mReturn(f)
        property mg : |λ| of mReturn(g)
        on |λ|(x)
            mf(x, mg(x))
        end |λ|
    end script
end apFn
```