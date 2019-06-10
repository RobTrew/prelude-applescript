```applescript
-- insert :: Ord a => a -> [a] -> [a]
on insert(x, ys)
    insertBy(my compare, x, ys)
end insert
```