```applescript
-- cartesianProduct :: [a] -> [b] -> [(a, b)]on cartesianProduct(xs, ys)	script		on |λ|(x)			script				on |λ|(y)					{Tuple(x, y)}				end |λ|			end script			concatMap(result, ys)		end |λ|	end script	concatMap(result, xs)end cartesianProduct
```