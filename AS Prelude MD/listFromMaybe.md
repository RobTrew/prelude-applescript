```applescript
-- The listFromMaybe function returns an empty list when given
-- Nothing or a singleton list when not given Nothing.
```

```applescript
-- listFromMaybe :: Maybe a -> [a]
on listFromMaybe(mb)
    -- A singleton list derived from a Just value, 
    -- or an empty list derived from Nothing.
    if Nothing of mb then
        {}
    else
        {Just of mb}
    end if
end maybeToList
```