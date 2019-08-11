```applescript
-- Right :: b -> Either a b
on |Right|(x)
    script
        property type : "Either"
        property |Left| : missing value
        property |Right| : x
    end script
end |Right|
```