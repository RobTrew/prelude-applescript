```applescript
-- isSubsequenceOf :: Eq a => [a] -> [a] -> Bool
-- isSubsequenceOf :: String -> String -> Bool
on isSubsequenceOf(xs, ys)
    script iss
        on |λ|(a, b)
            if a ≠ {} then
                if b ≠ {} then
                    if item 1 of a = item 1 of b then
                        |λ|(rest of a, rest of b)
                    else
                        |λ|(a, rest of b)
                    end if
                else
                    false
                end if
            else
                true
            end if
        end |λ|
    end script
    
    if class of xs = string then
        tell iss to |λ|(characters of xs, characters of ys)
    else
        tell iss to |λ|(xs, ys)
    end if
end isSubsequenceOf
```