```applescript
-- bindTuple (>>=) :: Monoid a => (a, a) -> (a -> (a, b)) -> (a, b)
on bindTuple(tpl, f)
    set t2 to mReturn(f)'s |λ|(|2| of tpl)
    Tuple(mappend(|1| of tpl, |1| of t2), |2| of t2)
end bindTuple
```