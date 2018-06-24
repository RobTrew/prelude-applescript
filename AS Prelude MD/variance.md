```applescript
-- variance :: [Num] -> Num
on variance(xs)
    set m to mean(xs)
    script
        on |λ|(a, x)
            a + (x - m) ^ 2
        end |λ|
    end script
    foldl(result, 0, xs) / ((length of xs) - 1)
end variance
```