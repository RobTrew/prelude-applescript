```applescript
-- memberDict :: Key -> Dict -> Bool
on memberDict(k, dct)
    ((current application's ¬
        NSDictionary's dictionaryWithDictionary:dct)'s ¬
        objectForKey:k) is not missing value
end member
```