```applescript
-- 'The mapAccumR function behaves like a combination of map and foldr; 
--  it applies a function to each element of a list, passing an accumulating 
--  parameter from |Right| to |Left|, and returning a final value of this 
--  accumulator together with the new list.' (see Hoogle)
-- mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumR(f, acc, xs)
    script
        on |λ|(x, a, i)
            tell mReturn(f) to set pair to |λ|(|1| of a, x, i)
            Tuple(|1| of pair, (|2| of pair) & |2| of a)
        end |λ|
    end script
    foldr(result, Tuple(acc, []), xs)
end mapAccumR
```