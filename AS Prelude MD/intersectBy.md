```applescript
-- intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
on intersectBy(eq, xs, ys)
	if length of xs > 0 and length of ys > 0 then
		set p to curry(eq)
		script matchFound
			on |λ|(x)
				any(p's |λ|(x), ys)
			end |λ|
		end script
		
		filter(matchFound, xs)
	else
		{}
	end if
end intersectBy
```