```applescript
-- Kleisli composition LR
-- kleisliCompose (>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
on kleisliCompose(f, g)
    script
        on |λ|(x)
            bind(mReturn(f)'s |λ|(x), g)
        end |λ|
    end script
end kleisliCompose
```