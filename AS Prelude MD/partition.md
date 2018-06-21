```applescript
-- partition :: predicate -> List -> (Matches, nonMatches)
```

```applescript
-- partition :: (a -> Bool) -> [a] -> ([a], [a])on partition(f, xs)	tell mReturn(f)		set ys to {}		set zs to {}		repeat with x in xs			set v to contents of x			if |λ|(v) then				set end of ys to v			else				set end of zs to v			end if		end repeat	end tell	Tuple(ys, zs)end partition
```