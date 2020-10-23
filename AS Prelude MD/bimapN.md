```applescript
-- bimapN :: (a -> b) -> (c -> d) -> TupleN -> TupleN
on bimapN(f, g, tplN)
    set z to length of tplN
    set k1 to (z - 1) as string
    set k2 to z as string
    
    insertDict(k2, mReturn(g)'s |λ|(Just of lookupDict(k2, tplN)), ¬
        insertDict(k1, mReturn(f)'s |λ|(Just of lookupDict(k1, tplN)), tplN))
end bimapN
```