```applescript
-- properFraction :: Real -> (Int, Real)
on properFraction(n)
    set i to (n div 1)
    Tuple(i, n - i)
end properFraction
```