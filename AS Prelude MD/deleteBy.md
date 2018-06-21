```applescript
-- deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]on deleteBy(fnEq, x, xs)	if length of xs > 0 then		set mb to uncons(xs)		if Nothing of mb then			xs		else			set ht to Just of mb			set {h, t} to {|1| of ht, |2| of ht}			if |λ|(x, h) of mReturn(fnEq) then				t			else				{h} & deleteBy(fnEq, x, t)			end if		end if	else		{}	end ifend deleteBy
```