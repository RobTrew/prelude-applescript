```applescript
-- List of (Predicate, value) tuples -> Default value -> Value to test -> Output value
-- caseOf :: [(a -> Bool, b)] -> b -> a ->  b
on caseOf (pvs, otherwise, x)
    repeat with tpl in pvs
        if mReturn(|1| of tpl)'s |λ|(x) then return |2| of tpl
    end repeat
    return otherwise
end caseOf
```