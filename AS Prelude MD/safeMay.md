```applescript
-- safeMay :: (a -> Bool) -> (a -> b) -> Maybe b
on safeMay(p, f, x)
    if p(x) then
        Just(f(x))
    else
        Nothing()
    end if
end safeMay
```