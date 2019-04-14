```applescript
-- succMay :: Enum a => a -> Maybe a
on succMay(x)
    if x is maxBound(x) then
        Nothing()
    else
        Just(toEnum(x)'s |λ|(fromEnum(x) + 1))
    end if
end succMay
```