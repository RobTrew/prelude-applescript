```applescript
-- takeIterate n f x == [x, f x, f (f x), ...]
```

```applescript
-- takeIterate :: Int -> (a -> a) -> a -> [a]on takeIterate(n, f, x)	set v to x	set vs to {v}	tell mReturn(f)		repeat with i from 1 to n - 1			set v to |λ|(v)			set end of vs to v		end repeat	end tell	return vsend takeIterate
```