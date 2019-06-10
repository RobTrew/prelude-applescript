```applescript
-- enumFromPairs :: String -> [(String, Int)] -> Dict
on enumFromPairs(strName, kvs)
    set iMax to item 1 of item -1 of kvs
    set iMin to item 1 of item 1 of kvs
    script go
        on |λ|(a, kv)
            set {k, v} to kv
            insertMap(insertMap(a, k, ¬
                {type:"enum", |name|:¬
                    strName, |key|:k, min:iMin, max:iMax, value:v}), v, k)
        end |λ|
    end script
    foldl(go, {|name|:strName, min:iMin, max:iMax}, kvs)
end enumFromPairs
```