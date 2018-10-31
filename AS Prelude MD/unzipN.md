```applescript
-- unzipN :: [(a,b,...)] -> ([a],[b],...)
on unzipN(tpls)
    if 0 < length of tpls then
        set xs to replicate(length of item 1 of tpls, {})
        script go
            on |λ|(a, tpl)
                script inner
                    on |λ|(x, i)
                        x & Just of lookupDict(i as string, tpl)
                    end |λ|
                end script
                map(inner, a)
            end |λ|
        end script
        foldl(go, xs, tpls)
    else
        missing value
    end if
end unzipN
```