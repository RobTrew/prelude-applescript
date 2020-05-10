```applescript
-- bool :: a -> a -> Bool -> a
on bool(ff, tf, bln)
    -- The evaluation of either tf or ff, depending on p
    if bln then
        set e to tf
    else
        set e to ff
    end if
    
    set c to class of e
    if {script, handler} contains c then
        |λ|() of mReturn(e)
    else
        e
    end if
end bool
```