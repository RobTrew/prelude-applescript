```applescript
-- takeWhile :: (a -> Bool) -> [a] -> [a]
-- takeWhile :: (Char -> Bool) -> String -> String
on takeWhile(p, xs)
    if script is class of xs then
        takeWhileGen(p, xs)
    else
        tell mReturn(p)
            repeat with i from 1 to length of xs
                if not |λ|(item i of xs) then ¬
                    return take(i - 1, xs)
            end repeat
        end tell
        return xs
    end if
end takeWhile
```