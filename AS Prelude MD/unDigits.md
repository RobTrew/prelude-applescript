```applescript
-- unDigits :: [Int] -> Int
on unDigits(ds)
    -- The integer with the given digits.
    script go
        on |λ|(a, x)
            10 * a + x
        end |λ|
    end script
    foldl(go, 0, ds)
end unDigits
```