```applescript
-- Given a curried/default function, returns an
-- equivalent function on a tuple or list pair.
```

```applescript
-- uncurry :: (a -> b -> c) -> ((a, b) -> c)
on uncurry(f)
    if 1 < argvLength(f) then
        script
            on |λ|(ab)
                if class of ab is list then
                    mReturn(f)'s |λ|(item 1 of ab, item 2 of ab)
                else
                    mReturn(f)'s |λ|(|1| of ab, |2| of ab)
                end if
            end |λ|
        end script
    else
        script
            on |λ|(ab)
                if class of ab is list then
                    f's |λ|(item 1 of ab)'s |λ|(item 2 of ab)
                else
                    f's |λ|(|1| of ab)'s |λ|(|2| of ab)
                end if
            end |λ|
        end script
    end if
end uncurry
```