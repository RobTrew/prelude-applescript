```applescript
-- showOutline :: Tree String -> String
on showOutline(x)
    script go
        on |λ|(indent)
            script
                on |λ|(tree)
                    {indent & (root of tree)} & ¬
                        concatMap(go's |λ|(tab & indent), ¬
                            nest of tree)
                end |λ|
            end script
        end |λ|
    end script
    unlines((go's |λ|(""))'s |λ|(x))
end showOutline
```