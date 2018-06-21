```applescript
-- > unfoldl (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
-- > [1,2,3,4,5,6,7,8,9,10]
```

```applescript
-- unfoldl :: (b -> Maybe (a, b)) -> b -> [a]on unfoldl(f, v)	set xr to Tuple(v, v) -- (value, remainder)	set xs to {}	tell mReturn(f)		repeat -- Function applied to remainder.			set mb to |λ|(|2| of xr)			if Nothing of mb then				exit repeat			else -- New (value, remainder) tuple,				set xr to Just of mb				-- and value appended to output list.				set xs to ({|1| of xr} & xs)			end if		end repeat	end tell	return xsend unfoldl
```