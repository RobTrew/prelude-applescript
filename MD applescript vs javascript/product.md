```javascript
// product :: [Num] -> Num
const product = xs =>
    xs.reduce((a, x) => a * x, 1);
```


```applescript
-- product :: [Num] -> Num
on product(xs)
    script multiply
        on |λ|(a, b)
            a * b
        end |λ|
    end script
    
    foldl(multiply, 1, xs)
end product
```