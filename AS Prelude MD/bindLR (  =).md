```applescript
-- bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
on bindLR(m, mf)
    if isRight(m) then
        mReturn(mf)'s |λ|(|Right| of m)
    else
        m
    end if
end bindLR
```