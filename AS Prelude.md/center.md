```applescript
-- center :: Int -> Char -> String -> Stringon |center|(n, cFiller, strText)	set lngFill to n - (length of strText)	if lngFill > 0 then		set strPad to replicate(lngFill div 2, cFiller) as text		set strCenter to strPad & strText & strPad		if lngFill mod 2 > 0 then			cFiller & strCenter		else			strCenter		end if	else		strText	end ifend |center|
```