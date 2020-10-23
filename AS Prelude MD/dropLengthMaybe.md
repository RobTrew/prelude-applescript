```applescript
-- dropLengthMaybe :: [a] -> [b] -> Maybe [b]
on dropLengthMaybe(xs, ys)
    script go
        on |λ|(x, y)
            if 0 < length of x then
                if 0 < length of y then
                    |λ|(tail(x), tail(y))
                else
                    Nothing()
                end if
            else
                Just(y)
            end if
        end |λ|
    end script
    go's |λ|(xs, ys)
end dropLengthMaybe
```