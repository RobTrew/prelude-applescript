```applescript
-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(f)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs)) 
    script
        on |λ|(xs)
            set lng to length of xs
            set i to 0
            tell mReturn(f)
                repeat while lng > i and |λ|(item (1 + i) of xs)
                    set i to 1 + i
                end repeat
            end tell
            splitAt(i, xs)
        end |λ|
    end script
end span
```


```javascript
// span, applied to a predicate p and a list xs, returns a tuple of xs of 
// elements that satisfy p and second element is the remainder of the list:
//
// > span (< 3) [1,2,3,4,1,2,3,4] == ([1,2],[3,4,1,2,3,4])
// > span (< 9) [1,2,3] == ([1,2,3],[])
// > span (< 0) [1,2,3] == ([],[1,2,3])
//
// span p xs is equivalent to (takeWhile p xs, dropWhile p xs) 
// span :: (a -> Bool) -> [a] -> ([a], [a])
const span = p =>
    // Longest prefix of xs consisting of elements which
    // all satisfy p, tupled with the remainder of xs.
    xs => {
        const
            ys = 'string' !== typeof xs ? (
                list(xs)
            ) : xs,
            iLast = ys.length - 1;
        return splitAt(
            until(
                i => iLast < i || !p(ys[i])
            )(i => 1 + i)(0)
        )(ys);
    };
```