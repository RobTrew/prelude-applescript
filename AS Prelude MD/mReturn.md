```applescript
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper. 
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
```