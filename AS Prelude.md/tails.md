```applescript
-- tails :: [a] -> [[a]]
on tails(xs)
	if class of xs is text then
		set xs_ to characters of xs
	else
		set xs_ to xs
	end if
	
	script
		on |λ|(_, i)
			items i thru -1 of xs_
		end |λ|
	end script
	
	map(result, xs_) & {{}}
end tails
```