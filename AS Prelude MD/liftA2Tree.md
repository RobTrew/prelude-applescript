```applescript
-- liftA2Tree :: Tree (a -> b -> c) -> Tree a -> Tree b -> Tree c
on liftA2Tree(f, tx, ty)
    
    script fx
        on |λ|(y)
            mReturn(f)'s |λ|(root of tx, y)
        end |λ|
    end script
    
    script fmapT
        on |λ|(t)
            fmapTree(fx, t)
        end |λ|
    end script
    
    script liftA2T
        on |λ|(t)
            liftA2Tree(f, t, ty)
        end |λ|
    end script
    
    if class of ty is list then
        set rootLabel to {}
        set forest to {}
    else
        set rootLabel to root of ty
        set forest to map(fmapT, nest of ty) & map(liftA2T, nest of tx)
    end if
    
    Node(mReturn(f)'s |λ|(root of tx, rootLabel), forest)
end liftA2Tree
```