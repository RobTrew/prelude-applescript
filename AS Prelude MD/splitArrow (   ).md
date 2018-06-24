```applescript
-- Compose a function (from a tuple to a tuple), 
-- (with separate transformations for fst and snd)
```

```applescript
-- splitArrow (***) :: (a -> b) -> (c -> d) -> ((a, c) -> (b, d))
on splitArrow(f, g)
    script
        on |λ|(xy)
            Tuple(mReturn(f)'s |λ|(|1| of xy), mReturn(g)'s |λ|(|2| of xy))
        end |λ|
    end script
end splitArrow
```