```applescript
-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        2 ^ 30 -- (simple proxy for non-finite)
    end if
end |length|
```