```applescript
-- cons :: a -> [a] -> [a]
on cons(x, xs)
    if list is class of xs then
        {x} & xs
    else
        x & xs
    end if
end cons
```