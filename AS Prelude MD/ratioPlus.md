```applescript
-- ratioPlus :: Rational -> Rational -> Rational
on ratioPlus(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    set d to lcm(d of r1, d of r2)
    ratio((n of r1) * (d / (d of r1) + ¬
        ((n of r2) * (d / (d of r2)))), d)
end ratioPlus
```