```js
-- tupleFromArray [a] -> (a, a ...)on tupleFromArray(xs)	set lng to length of xs	if lng > 1 then		if lng > 2 then			set strSuffix to lng as string		else			set strSuffix to ""		end if		script kv			on |λ|(a, x, i)				insertMap(a, (i as string), x)			end |λ|		end script		foldl(kv, {type:"Tuple" & strSuffix}, xs)	else		missing value	end ifend tupleFromArray
```