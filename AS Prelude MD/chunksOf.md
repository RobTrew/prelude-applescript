```applescript
-- chunksOf :: Int -> [a] -> [[a]]on chunksOf(k, xs)	script		on go(ys)			set ab to splitAt(k, ys)			set a to |1| of ab			if {} ≠ a then				{a} & go(|2| of ab)			else				a			end if		end go	end script	result's go(xs)end chunksOf
```