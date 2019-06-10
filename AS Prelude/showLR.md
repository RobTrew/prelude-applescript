```applescript
-- showLR :: Either a b -> String
on showLR(lr)
    if isRight(lr) then
        "Right(" & unQuoted(show(|Right| of lr)) & ")"
    else
        "Left(" & unQuoted(show(|Left| of lr)) & ")"
    end if
end showLR
```