```applescript
-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if isRight(e) then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either
```