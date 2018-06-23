```applescript
-- mappendMaybe (<>) :: Maybe a -> Maybe a -> Maybe aon mappendMaybe(a, b)	if Nothing of a then		b	else if Nothing of b then		a	else		Just(mappend(Just of a, Just of b))	end ifend mappendMaybe
```