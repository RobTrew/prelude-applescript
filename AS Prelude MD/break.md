```applescript
-- break :: (a -> Bool) -> [a] -> ([a], [a])
on break(p, xs)
    set bln to false
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then
                set bln to true
                exit repeat
            end if
        end repeat
    end tell
    if bln then
        if 1 < i then
            {items 1 thru (i - 1) of xs, items i thru -1 of xs}
        else
            {{}, xs}
        end if
    else
        {xs, {}}
    end if
end break
```