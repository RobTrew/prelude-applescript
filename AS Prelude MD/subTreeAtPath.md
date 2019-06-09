```applescript
-- subTreeAtPath :: Tree String -> [String] -> Maybe Tree String
on subTreeAtPath(tree, pathSegments)
    script go
        on |λ|(children, xs)
            if {} ≠ children and {} ≠ xs then
                set h to item 1 of xs
                script parentMatch
                    on |λ|(t)
                        h = root of t
                    end |λ|
                end script
                script childMatch
                    on |λ|(t)
                        if 1 < length of xs then
                            |λ|(nest of t, rest of xs) of go
                        else
                            Just(t)
                        end if
                    end |λ|
                end script
                bindMay(find(parentMatch, children), childMatch)
            else
                Nothing()
            end if
        end |λ|
    end script
    |λ|({tree}, pathSegments) of go
end subTreeAtPath
```