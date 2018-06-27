```applescript
-- traverseMay :: Applicative f => (t -> f a) -> Maybe t -> f (Maybe a)
on traverseMay(f, mb)
    if Nothing of mb then
        {mb}
    else
        fmap(my Just, mReturn(f)'s |λ|(Just of mb))
    end if
end traverseMay
```