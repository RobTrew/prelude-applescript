```applescript
-- rotated :: Int -> [a] -> [a]
on rotated(n, xs)
    set lng to length of xs
    set m to |mod|(n, lng)
    
    if 0 ≠ n then
        (items (1 + m) thru -1 of xs) & ¬
            (items 1 thru m of xs)
    else
        xs
    end if
end rotated
```