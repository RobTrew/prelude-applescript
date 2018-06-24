```applescript
-- isLeft :: Either a b -> Bool
on isLeft(x)
    set dct to current application's ¬
        NSDictionary's dictionaryWithDictionary:x
    (dct's objectForKey:"type") as text = "Either" and ¬
        (dct's objectForKey:"Right") as list = {missing value}
end isLeft
```