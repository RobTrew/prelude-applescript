```applescript
-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script go
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to nd_
            set r_ to f's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    |λ|(quotRem(n, base), rs) of go
end showIntAtBase
```