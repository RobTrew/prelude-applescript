```applescript
-- Where the `rows` tuple is a list of lists in the Applescript version
```

```applescript
-- zipWithN :: (a -> b -> ... -> c) -> ([a], [b] ...) -> [c]
on zipWithN(f, rows)
    script go
        property mf: mReturn(f)'s |λ|
        on |λ|(i)
            script nth
                on |λ|(row)
                    item i of row
                end |λ|
            end script
            mf(map(nth, rows))
        end |λ|
    end script
    map(go, enumFromTo(1, minimum(map(my |length|, rows))))
end
```

```js
// zipWithN :: (a -> b -> ... -> c) -> ([a], [b] ...) -> [c]
function zipWithN() {
    const
        args = Array.from(arguments),
        rows = args.slice(1),
        f = args[0];
    return 1 < rows.length ? map(
        i => f(...map(r => r[i], rows)),
        enumFromTo(
            0,
            Math.min(...map(length, rows)) -1,
        )
    ) : rows;
}

// or

// zipWithN :: (a -> b -> ... -> c) -> ([a], [b] ...) -> [c]
// const zipWithN = (f, tplLists) =>
//     map(x => f(...Array.from(x)),
//         zipN(...Array.from(tplLists))
//     );
```