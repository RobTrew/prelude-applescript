```applescript
-- sum :: [Num] -> Num
on sum(xs)
    set ca to current application
    ((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@sum.self") as real
end sum
```