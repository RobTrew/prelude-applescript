```applescript
-- Instance for lists only here

-- e.g. replicateM(3, {1, 2})) -> 
-- {{1, 1, 1}, {1, 1, 2}, {1, 2, 1}, {1, 2, 2}, {2, 1, 1}, 
--  {2, 1, 2}, {2, 2, 1}, {2, 2, 2}}
-- replicateM :: Int -> [a] -> [[a]]
on replicateM(n, xs)
    script go
        script cons
            on |λ|(a, bs)
                {a} & bs
            end |λ|
        end script
        on |λ|(x)
            if x ≤ 0 then
                {{}}
            else
                liftA2List(cons, xs, |λ|(x - 1))
            end if
        end |λ|
    end script
    
    go's |λ|(n)
end replicateM
```