```applescript
-- takeWhile :: (a -> Bool) -> [a] -> [a]on takeWhile(p, xs)	set bln to false	tell mReturn(p)		repeat with i from 1 to length of xs			if not |λ|(item i of xs) then				set bln to true				exit repeat			end if		end repeat	end tell	if bln then		if i > 1 then			items 1 thru (i - 1) of xs		else			{}		end if	else		xs	end ifend takeWhile
```