```applescript
-- findIndices :: (a -> Bool) -> [a] -> [Int]
on findIndices(p, xs)
    script
        property f : mReturn(p)'s |λ|
        on |λ|(x, i)
            if f(x) then
                {i}
            else
                {}
            end if
        end |λ|
    end script
    concatMap(result, xs)
end findIndices
```