```applescript
-- composeListR :: [(a -> a)] -> (a -> a)
on composeListR(fs)
    script
        on |λ|(x)
            script go
                on |λ|(a, f)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script
            
            foldl(go, x, fs)
        end |λ|
    end script
end composeListLR
```