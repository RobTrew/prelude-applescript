```applescript
-- dictFromList :: [(k, v)] -> Dict
on dictFromList(kvs)
    set tpl to unzip(kvs)
    script
        on |λ|(x)
            x as string
        end |λ|
    end script
    tell current application
        (its (NSDictionary's dictionaryWithObjects:(item 2 of tpl) ¬
            forKeys:(my map(result, item 1 of tpl)))) as record
    end tell
end dictFromList
```