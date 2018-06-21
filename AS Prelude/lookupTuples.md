```applescript
-- lookupTuples :: Eq a => a -> [(a, b)] -> Maybe bon lookupTuples(k, xs)	script keyMatch		on |λ|(x)			k = fst(x)		end |λ|	end script		script harvestMay		on |λ|(kv)			Just(snd(kv))		end |λ|	end script		bindMay(find(keyMatch, xs), harvestMay)end lookupTuples
```