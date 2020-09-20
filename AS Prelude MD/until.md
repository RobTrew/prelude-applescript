```applescript
-- until :: (a -> Bool) -> (a -> a) -> a -> aon |until|(p, f, x)	set v to x	set mp to mReturn(p)	set mf to mReturn(f)	repeat until mp's |λ|(v)		set v to mf's |λ|(v)	end repeat	vend |until|
```