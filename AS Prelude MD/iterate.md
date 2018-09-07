```applescript
-- iterate :: (a -> a) -> a -> Generator [a]
on iterate(f, x)
    script
        property v : missing value
        property i : missing value
        property g : mReturn(f)'s |λ|
        on |λ|()
            if v is missing value then
                set v to x
                set i to 1
            else
                set i to 1 + i
                set v to g(v, i)
            end if
            return v
        end |λ|
    end script
end iterate
```