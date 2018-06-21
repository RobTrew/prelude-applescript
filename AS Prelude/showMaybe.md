```applescript
-- showMaybe :: Maybe a -> Stringon showMaybe(mb)	if Nothing of mb then		"Nothing"	else		"Just " & unQuoted(show(Just of mb))	end ifend showMaybe
```