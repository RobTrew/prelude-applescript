```applescript
-- splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
-- splitBy :: (String -> String -> Bool) -> String -> [String]
on splitBy(p, xs)
    if length of xs < 2 then
        {xs}
    else
        script f
            property mp : |λ| of mReturn(p)
            on |λ|(a, x)
                set {acc, active, prev} to a
                if mp(prev, x) then
                    {acc & {active}, {x}, x}
                else
                    {acc, active & x, x}
                end if
            end |λ|
        end script
        
        set h to item 1 of xs
        set lstParts to foldl(f, {{}, {h}, h}, items 2 thru -1 of xs)
        if class of item 1 of xs = string then
            map(concat, (item 1 of lstParts & {item 2 of lstParts}))
        else
            item 1 of lstParts & {item 2 of lstParts}
        end if
    end if
end splitBy
```