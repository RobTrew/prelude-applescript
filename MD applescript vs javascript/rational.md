```applescript
-- rational :: Num a => a -> Rational
```


```javascript
// rational :: Num a => a -> Rational
const rational = x =>
    isNaN(x) ? x : Number.isInteger(x) ? (
        ratio(x)(1)
    ) : approxRatio(undefined)(x);
```