```applescript
-- enumFromThen :: Int -> Int -> Gen [Int]
on enumFromThen(m, n)
    -- A non-finite stream of integers,
    -- starting with m and n, and continuing
    -- with the same interval.
    script
        property d : n - m
        property v : m
        on |λ|()
            set x to v
            set v to d + v
            return x
        end |λ|
    end script
end enumFromThen
```