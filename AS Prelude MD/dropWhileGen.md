```applescript
-- dropWhileGen :: (a -> Bool) -> Gen [a] -> [a]
on dropWhileGen(p, xs)
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set v to xs's |λ|()
        end repeat
    end tell
    return cons(v, xs)
end dropWhileGen
```