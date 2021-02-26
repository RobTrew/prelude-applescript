```applescript
-- maximum :: Ord a => [a] -> a
on maximum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@max.self")
end maximum
```