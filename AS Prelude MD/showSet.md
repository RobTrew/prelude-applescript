```applescript
-- showSet :: Set a -> String
on showSet(s)
    script str
        on |λ|(x)
            x as string
        end |λ|
    end script
    "{" & intercalate(", ", map(str, sort(elems(s)))) & "}"
end showSet
```