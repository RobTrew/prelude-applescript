```applescript
-- succ :: Enum a => a -> a
on succ(x)
    if isChar(x) then
        chr(1 + ord(x))
    else
        1 + x
    end if
end succ
```