```applescript
-- Takes a predicate function and a list and
-- returns Just( the 1-based index of the first
-- element ) in the list satisfying the predicate
-- or Nothing if there is no such element.
```

```applescript
-- findIndex(isSpace, "hello world")
--> {type:"Maybe", Nothing:false, Just:6}

-- findIndex(even, [3, 5, 7, 8, 9])
--> {type:"Maybe", Nothing:false, Just:4}

-- findIndex(isUpper, "all lower case")
--> {type:"Maybe", Nothing:true}
```

```applescript
-- findIndex :: (a -> Bool) -> [a] -> Maybe Int
on findIndex(p, xs)
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return Just(i)
        end repeat
        return Nothing()
    end tell
end findIndex
```