```applescript
-- Not distinct, in Applescript, from the default curry.
-- (In JavaScript we have a choice between two-argument and N-argument currying,
-- but for want of a way of detecting arity at run-time, the arbitrary
-- N-argument version seems hard to implement in Applescript)
```

```applescript
-- curry2 :: ((a, b) -> c) -> a -> b -> c
on curry2(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry
```