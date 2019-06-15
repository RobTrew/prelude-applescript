```applescript
-- join :: Monad m => m (m a) -> m a
on join(x)
    bind(x, my identity)
end join
```