```applescript
-- listFromTuple :: (a, a ...) -> [a]
on listFromTuple(tpl)
    items 2 thru -2 of (tpl as list)
end listFromTuple
```