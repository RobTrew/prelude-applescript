```applescript
-- Lift 2nd class handler function into 1st class script wrapper 
```

```applescript
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
```