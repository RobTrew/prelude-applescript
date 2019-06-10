```applescript
-- curry3 :: ((a, b, c) -> d) -> a -> b -> c -> d
on curry3(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    script
                        on |λ|(c)
                            |λ|(a, b, c) of mReturn(f)
                        end |λ|
                    end script
                end |λ|
            end script
        end |λ|
    end script
end curry3
```