```applescript
-- Sort and group a list by comparing the results of a key function
-- applied to each element. groupSortOn f is equivalent to
-- groupBy eq $ sortBy (comparing f),
-- but has the performance advantage of only evaluating f once for each
-- element in the input list.
-- This is a decorate-(group.sort)-undecorate pattern, as in the
-- so-called 'Schwartzian transform'.
-- Groups are arranged from from lowest to highest.
```

```applescript
-- groupSortOn :: Ord b => (a -> b) -> [a] -> [a]
```