```applescript
-- sum :: [Num] -> Num
on sum(xs)
	script add
		on |λ|(a, b)
			a + b
		end |λ|
	end script
	
	foldl(add, 0, xs)
end sum
```