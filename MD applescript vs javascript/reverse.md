```applescript
-- reverse :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|
```


```javascript
// reverse :: [a] -> [a]
const reverse = xs =>
    'string' !== typeof xs ? (
        xs.slice(0).reverse()
    ) : xs.split('').reverse().join('');
```