```applescript
-- drop :: Int -> [a] -> [a]
on drop(n, xs)
    if n < length of xs then
        if text is class of xs then
            text (n + 1) thru -1 of xs
        else
            items (n + 1) thru -1 of xs
        end if
    else
        {}
    end if
end drop
```