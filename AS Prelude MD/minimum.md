```applescript
-- minimum :: Ord a => [a] -> a
on minimum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@min.self")
end minimum
```