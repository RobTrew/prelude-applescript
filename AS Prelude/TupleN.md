```applescript
-- Requires N arguments to be wrapped as one list in AS 
-- (the JS version accepts N separate arguments)
```

```applescript
-- TupleN :: a -> b ...  -> (a, b ... )
on TupleN(argv)
    tupleFromList(argv)
end TupleN
```