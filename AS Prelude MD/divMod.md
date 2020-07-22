```applescript
-- divMod :: Int -> Int -> (Int, Int)
on divMod(n, d)
    -- Integer division, truncated toward negative infinity,
    -- and integer modulus such that:
    -- (x `div` y)*y + (x `mod` y) == x
    set {q, r} to {n div d, n mod d}
    if signum(r) = signum(-d) then
        {q - 1, r + d}
    else
        {q, r}
    end if
end divMod
```