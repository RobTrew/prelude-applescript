```applescript
-- traverse :: (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b)
on traverse(f, tx)
    if class of tx is list then
        traverseList(f, tx)
    else if class of tx is record and keys(tx) contains "type" then
        set t to type of tx
        if "Either" = t then
            traverseLR(f, tx)
        else if "Maybe" = t then
            traverseMay(f, tx)
        else if "Node" = t then
            traverseTree(f, tx)
        else if "Tuple" = t then
            traverseTuple(f, tx)
        else
            missing value
        end if
    else
        missing value
    end if
end traverse
```