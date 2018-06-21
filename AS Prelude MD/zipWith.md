```applescript
-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
	set lng to min(length of xs, length of ys)
	if lng < 1 then return {}
	set lst to {}
	tell mReturn(f)
		repeat with i from 1 to lng
			set end of lst to |λ|(item i of xs, item i of ys)
		end repeat
		return lst
	end tell
end zipWith
```