```applescript
-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    -- The 'maybe' function takes a default value, a function, and a 'Maybe'
    -- value.  If the 'Maybe' value is 'Nothing', the function returns the
    -- default value.  Otherwise, it applies the function to the value inside
    -- the 'Just' and returns the result.
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe
```