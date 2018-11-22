```applescript
-- Where rows is a list of lists in the Applescript version
```

```applescript
-- zipWithN :: (a -> b -> ... -> c) -> ([a], [b] ...) -> [c]
on zipWithN(f, rows)
    script go
        property mf : mReturn(f)
        on |λ|(i)
            script nth
                on |λ|(row)
                    item i of row
                end |λ|
            end script
            mf's |λ|(map(nth, rows))
        end |λ|
    end script
    map(go, enumFromTo(1, minimum(map(my |length|, rows))))
end zipWithN
```