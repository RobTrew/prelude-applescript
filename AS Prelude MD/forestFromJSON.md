```applescript
-- forestFromJSON :: String -> [Tree a]
on forestFromJSON(strJSON)
    set lr to jsonParseLR(strJSON)
    if missing value is |Left| of lr then
        map(my treeFromNestedList, |Right| of lr)
    else
        {}
    end if
end forestFromJSON

```