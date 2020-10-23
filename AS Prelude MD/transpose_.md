```applescript
-- Simplified version - assuming rows of unvarying length.
-- transpose_ :: [[a]] -> [[a]]on transpose_(rows)	script cols		on |λ|(_, iCol)			script cell				on |λ|(row)					item iCol of row				end |λ|			end script			concatMap(cell, rows)		end |λ|	end script	map(cols, item 1 of rows)end transpose_
```