```javascript
// ratioDiv :: Rational -> Rational -> Rational
const ratioDiv = n1 => n2 => {
    const [r1, r2] = [n1, n2].map(rational);

    return Ratio(r1.n * r2.d)(
        r1.d * r2.n
    );
};
```


```applescript
-- ratioDiv :: Rational -> Rational -> Rational
on ratioDiv(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    ratio((n of r1) * (d of r2), (d of r1) * (n of r2))
end ratioDiv
```