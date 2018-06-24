```applescript
-- Just :: a -> Just a
on Just(x)
    {type: "Maybe", Nothing:false, Just:x}
end Just
```