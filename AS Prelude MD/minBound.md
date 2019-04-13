```applescript
-- minBound :: a -> a
on minBound(x)
    set c to class of x
    if text is c then
        character id 1
    else if integer is c then
        -(2 ^ 29 - 1)
    else if real is c then
        -1.797693E+308
    else if boolean is c then
        false
    end if
end minBound
```