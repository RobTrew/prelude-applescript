```applescript
-- chunksOf :: Int -> [a] -> [[a]]on chunksOf(k, xs)	script		on go(ys)			set ab to splitAt(k, ys)			set a to |1| of ab			if isNull(a) then				{}			else				{a} & go(|2| of ab)			end if		end go	end script	result's go(xs)end chunksOf
```