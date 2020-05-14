```applescript
-- second :: (a -> b) -> ((c, a) -> (c, b))
on |second|(f)
-- Lift a simple function to one which applies to a tuple, 
-- transforming only the second item of that tuple
    script
        on |λ|(xy)
            Tuple(|1| of xy, mReturn(f)'s |λ|(|2| of xy))
        end |λ|
    end script
end |second|
```