```applescript
-- mapKeys :: (Key -> Key) -> IntMap a -> IntMap aon mapKeys(f, dct)	script		property g : mReturn(f)		on |λ|(kv)			set {k, v} to kv			{g's |λ|(k), v}		end |λ|	end script	map(result, zip(keys(dct), elems(dct)))end mapKeys
```