```applescript
-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(f, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs)) 
    set lng to length of xs
    set i to 0
    tell mReturn(f)
        repeat while i < lng and |λ|(item (i + 1) of xs)
            set i to i + 1
        end repeat
    end tell
    splitAt(i, xs)
end span
```