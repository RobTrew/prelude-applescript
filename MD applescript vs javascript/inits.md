```applescript
-- inits :: [a] -> [[a]]
-- inits :: String -> [String]
on inits(xs)
    script elemInit
        on |λ|(_, i, xs)
            items 1 thru i of xs
        end |λ|
    end script
    
    script charInit
        on |λ|(_, i, xs)
            text 1 thru i of xs
        end |λ|
    end script
    
    if class of xs is string then
        {""} & map(charInit, xs)
    else
        {{}} & map(elemInit, xs)
    end if
end inits
```


```javascript
// inits([1, 2, 3]) -> [[], [1], [1, 2], [1, 2, 3]
// inits('abc') -> ["", "a", "ab", "abc"]
// inits :: [a] -> [[a]]
// inits :: String -> [String]
const inits = xs => [
    []
].concat((list(xs))
    .map((_, i, ys) => ys.slice(0, 1 + i)));
```