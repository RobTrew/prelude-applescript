```javascript
// treeLeaves :: Tree a -> [Tree a]
const treeLeaves = tree => {
    const go = t => {
        const xs = nest(t);

        return 0 < xs.length
            ? xs.flatMap(go)
            : [t];
    };

    return go(tree);
};
```


```applescript
-- treeLeaves :: Tree -> [Tree]
on treeLeaves(oNode)
    script go
        on |λ|(x)
            set lst to nest of x
            if 0 < length of lst then
                concatMap(my treeLeaves, lst)
            else
                {x}
            end if
        end |λ|
    end script
    |λ|(oNode) of go
end treeLeaves
```