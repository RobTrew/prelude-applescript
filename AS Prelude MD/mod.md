```applescript
-- mod :: Int -> Int -> Int
on |mod|(n, d)
    if signum(n) = signum(-d) then
        (n mod d) + d
    else
        (n mod d)
    end if
end |mod|
```