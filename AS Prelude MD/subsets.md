```applescript
-- subsets :: [a] -> [[a]]
on subsets(xs)
    script go
        on |λ|(ys)
            if 0 < length of ys then
                set h to item 1 of ys
                set zs to |λ|(rest of ys)
                script hcons
                    on |λ|(z)
                        {h} & z
                    end |λ|
                end script
                zs & map(hcons, zs)
            else
                {{}}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end subsets
```