```applescript
-- apTree (<*>) :: Tree (a -> b) -> Tree a -> Tree b
on apTree(tf, tx)
    set fmap to curry(my fmapTree)
    script go
        on |λ|(t)
            set f to root of t
            Node(mReturn(f)'s |λ|(root of tx), ¬
                map(fmap's |λ|(f), nest of tx) & ¬
                map(go, nest of t))
        end |λ|
    end script
    
    return go's |λ|(tf)
end apTree
```