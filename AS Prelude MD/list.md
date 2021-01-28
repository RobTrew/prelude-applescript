```applescript
-- list :: Gen [a] -> [a]
on |list|(gen)
    -- A strict list derived from a lazy generator.    
    set xs to {}
    set x to |λ|() of gen
    repeat while missing value ≠ x
        set end of xs to x
        set x to |λ|() of gen
    end repeat
    return xs
end |list|
```