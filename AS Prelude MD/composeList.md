```applescript
-- composeList :: [(a -> a)] -> (a -> a)
on composeList(fs)
    script
        on |λ|(x)
            script go
                on |λ|(f, a)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script
            foldr(go, x, fs)
        end |λ|
    end script
end composeList
```