```applescript
-- foldr1 :: (a -> a -> a) -> [a] -> a
on foldr1(f, xs)
    if length of xs > 1 then
        tell mReturn(f)
            set v to item -1 of xs
            set lng to length of xs
            repeat with i from lng - 1 to 1 by -1
                set v to |λ|(item i of xs, v, i, xs)
            end repeat
            return v
        end tell
    else
        xs
    end if
end foldr1
```


```javascript
// foldr1 :: (a -> a -> a) -> [a] -> a
const foldr1 = f =>
    xs => (ys => 0 < ys.length ? (
        init(ys).reduceRight(
            uncurry(f),
            last(ys)
        )
    ) : [])(list(xs));
```