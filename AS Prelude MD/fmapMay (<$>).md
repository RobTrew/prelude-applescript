```applescript
-- fmapMay (<$>) :: (a -> b) -> Maybe a -> Maybe b
on fmapMay(f, mb)
    if Nothing of mb then
        mb
    else
        Just(|λ|(Just of mb) of mReturn(f))
    end if
end fmapMay
```