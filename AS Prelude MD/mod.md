```applescript
-- mod :: Int -> Int -> Int
on |mod|(n, d)
    -- The built-in infix `mod` inherits the sign of the 
    -- *dividend* for non zero results. 
    -- (i.e. the 'rem' pattern in some languages).
    --
    -- This version inherits the sign of the *divisor*.
    -- (A more typical 'mod' pattern, and useful,
    -- for example with biredirectional list rotations).
    if signum(n) = signum(-d) then
        (n mod d) + d
    else
        (n mod d)
    end if
end |mod|
```