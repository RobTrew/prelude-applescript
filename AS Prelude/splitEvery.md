```applescript
-- splitEvery :: Int -> [a] -> [[a]]
on splitEvery(n, xs)
    if length of xs ≤ n then
        {xs}
    else
        set grp_t to splitAt(n, xs)
        {|1| of grp_t} & splitEvery(n, |2| of grp_t)
    end if
end splitEvery
```