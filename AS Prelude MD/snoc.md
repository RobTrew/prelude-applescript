```applescript
-- Mirror image of cons
-- New copy of the list, with an atom added at the end
-- snoc :: [a] -> a -> [a]
on snoc(xs, x)
    xs & {x}
end snoc
```