```applescript
-- elems :: Map k a -> [a]
-- elems :: Set a -> [a]
on elems(x)
    if record is class of x then -- Dict
        set ca to current application
        (ca's NSDictionary's dictionaryWithDictionary:rec)'s allValues() as list
    else -- Set
        (x's allObjects()) as list
    end if
end elems
```