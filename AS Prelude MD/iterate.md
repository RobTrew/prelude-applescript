```applescript
-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g's |λ|(v)
            end if
            return v
        end |λ|
    end script
end iterate
```