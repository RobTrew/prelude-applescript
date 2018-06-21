```applescript
-- deleteFirst :: a -> [a] -> [a]
on deleteFirst(x, xs)
    script Eq
        on |λ|(a, b)
            a = b
        end |λ|
    end script
 
    deleteBy(Eq, x, xs)
end |delete|
```