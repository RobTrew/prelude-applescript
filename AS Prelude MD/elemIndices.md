```applescript
-- elemIndices :: Eq a => a -> [a] -> [Int]on elemIndices(x, xs)	script		on |λ|(y, i)			if y = x then				{i}			else				{}			end if		end |λ|	end script	concatMap(result, xs)end elemIndices
```