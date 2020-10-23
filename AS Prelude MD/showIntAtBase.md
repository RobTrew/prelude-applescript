```applescript
-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script showIt
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to ({|1|, |2|} of nd_)
            set r_ to f's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    showIt's |λ|(quotRem(n, base), rs)
end showIntAtBase
```