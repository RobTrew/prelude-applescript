```applescript
-- filter :: (a -> Bool) -> [a] -> [a]on filter(p, xs)    tell mReturn(p)        set n to length of xs        set ys to {}                repeat with i from 1 to n            set v to item i of xs            if |λ|(v, i, xs) then set end of ys to v        end repeat        ys    end tellend filter
```