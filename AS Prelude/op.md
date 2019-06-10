```applescript
-- Derive a script with |λ| handler from the name of an infix operator
```

```applescript
-- op :: String -> (a -> a -> b)
on op(strOp)
    run script "script\non |λ|(a, b)\na " & strOp & " b\nend |λ|\nend script"
end op
```