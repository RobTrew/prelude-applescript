```applescript
-- predMay :: Enum a => a -> Maybe a
on predMay(x)
    if x is minBound(x) then
        Nothing()
    else
        Just(toEnum(x)'s |λ|(fromEnum(x) - 1))
    end if
end predMay
```