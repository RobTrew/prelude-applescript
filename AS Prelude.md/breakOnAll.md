```applescript
-- breakOnAll "::" ""
-- ==> []
-- breakOnAll "/" "a/b/c/"
-- ==> [("a", "/b/c/"), ("a/b", "/c/"), ("a/b/c", "/")]
```

```applescript
-- breakOnAll :: String -> String -> [(String, String)]on breakOnAll(pat, src)	if pat ≠ "" then		script			on |λ|(a, _, i, xs)				if i > 1 then					a & {Tuple(intercalate(pat, take(i - 1, xs)), ¬						pat & intercalate(pat, drop(i - 1, xs)))}				else					a				end if			end |λ|		end script		foldl(result, {}, splitOn(pat, src))	else		missing value	end ifend breakOnAll
```