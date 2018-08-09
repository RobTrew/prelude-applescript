```applescript
-- join :: Monad m => m (m a) -> m a
on join(x)
    bind(x, |id|)
end join
```