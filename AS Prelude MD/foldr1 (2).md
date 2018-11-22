```python
# foldr1 :: (a -> a -> a) -> [a] -> a
def foldr1(f):
    return lambda xs: reduce(
        uncurry(f), xs[:-1], xs[-1]
    ) if xs else None
```