```applescript
-- takeFromThenTo :: Int -> Int -> Int -> [a] -> [a]
on takeFromThenTo(a, b, z, xs)
    script go
        on |λ|(i)
            item (1 + i) of xs
        end |λ|
    end script
    map(go, enumFromThenTo(a, b, z))
end takeFromThenTo
```