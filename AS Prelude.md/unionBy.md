```applescript
-- unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]on unionBy(fnEq, xs, ys)	script flipDeleteByEq		on |λ|(xs, x)			deleteBy(fnEq, x, xs)		end |λ|	end script	xs & foldl(flipDeleteByEq, nubBy(fnEq, ys), xs)end unionBy
```