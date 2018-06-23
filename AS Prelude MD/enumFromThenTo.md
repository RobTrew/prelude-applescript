```applescript
-- enumFromThenTo :: Enum a => a -> a -> a -> [a]on enumFromThenTo(x1, x2, y)	if class of x1 is integer then		enumFromThenToInt(x1, x2, y)	else		enumFromThenToChar(x1, x2, y)	end ifend enumFromThenTo
```