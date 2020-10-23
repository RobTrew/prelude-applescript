```applescript
-- ratioDiv :: Rational -> Rational -> Rational
on ratioDiv(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    ratio((n of r1) * (d of r2), (d of r1) * (n of r2))
end ratioDiv
```