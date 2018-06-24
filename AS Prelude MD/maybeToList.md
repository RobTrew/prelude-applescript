```applescript
-- The maybeToList function returns an empty list when given
-- Nothing or a singleton list when not given Nothing.
```

```applescript
-- maybeToList :: Maybe a -> [a]
on maybeToList(mb)
    if Nothing of mb then
        {}
    else
        {Just of mb}
    end if
end maybeToList
```