```applescript
-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    -- A list of step-wise pairs drawn from xs and ys
    -- up to the length of the shorter of those lists.
    set lng to min(length of xs, length of ys)
    set zs to {}
    repeat with i from 1 to lng
        set end of zs to {item i of xs, item i of ys}
    end repeat
    return zs
end zip
```