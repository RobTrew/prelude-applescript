```applescript
-- scanr1 :: (a -> a -> a) -> [a] -> [a]on scanr1(f, xs)	if length of xs > 0 then		scanr(f, item -1 of xs, init(xs))	else		{}	end ifend scanr1
```