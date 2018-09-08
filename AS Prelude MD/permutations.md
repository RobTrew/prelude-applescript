```applescript
-- permutations :: [a] -> [[a]]
on permutations(xs)
    script go
        on |λ|(xs)
            script h
                on |λ|(x)
                    script ts
                        on |λ|(ys)
                            {{x} & ys}
                        end |λ|
                    end script
                    concatMap(ts, go's |λ|(|delete|(x, xs)))
                end |λ|
            end script
            
            if 0 < length of xs then
                concatMap(h, xs)
            else
                {{}}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end permutations
```