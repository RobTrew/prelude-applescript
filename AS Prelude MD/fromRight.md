```applescript
-- fromRight :: b -> Either a b -> b
on fromRight(def, lr)
    if isRight(lr) then
        |Right| of lr
    else
        def
    end if
end fromRight
```