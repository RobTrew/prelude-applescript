```applescript
-- jsonFromTree :: Tree a -> String
on jsonFromTree(tree)
    script go
        on |λ|(x)
            {root of x, map(go, nest of x)}
        end |λ|
    end script
    set ca to current application
    ca's (NSString's alloc()'s ¬
        initWithData:((ca's (NSJSONSerialization's ¬
            dataWithJSONObject:(|λ|(tree) of go) ¬
                options:0 |error|:(missing value)))) ¬
            encoding:(ca's NSUTF8StringEncoding)) as string
end jsonFromTree
```