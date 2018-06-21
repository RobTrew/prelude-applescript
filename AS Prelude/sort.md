```applescript
-- sort :: Ord a => [a] -> [a]
on sort(xs)
	((current application's NSArray's arrayWithArray:xs)'s ¬
		sortedArrayUsingSelector:"compare:") as list
end sort
```