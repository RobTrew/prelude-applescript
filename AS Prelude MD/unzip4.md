```applescript
-- unzip4 :: [(a,b,c,d)] -> ([a],[b],[c],[d])
on unzip4(wxyzs)
    set ws to {}
    set xs to {}
    set ys to {}
    set zs to {}
    repeat with wxyz in wxyzs
        set end of ws to |1| of wxyz
        set end of xs to |2| of wxyz
        set end of ys to |3| of wxyz
        set end of zs to |4| of wxyz
    end repeat
    return TupleN({ws, xs, ys, zs})
end unzip4
```