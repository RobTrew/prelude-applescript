```applescript
-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A lazy (generator) list unfolded from a seed value
    -- by repeated application of f to a value until no
    -- residue remains. Dual to fold/reduce.
    -- f returns either nothing (missing value) 
    -- or just (value, residue).
    script
        property valueResidue : {v, v}
        property g : mReturn(f)
        on |λ|()
            set valueResidue to g's |λ|(item 2 of (valueResidue))
            if missing value ≠ valueResidue then
                item 1 of (valueResidue)
            else
                missing value
            end if
        end |λ|
    end script
end unfoldr
```