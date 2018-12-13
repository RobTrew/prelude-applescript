```applescript
-- cons :: a -> [a] -> [a]
on cons(x, xs)
    set c to class of xs
    if list is c then
        {x} & xs
    else if script is c then
        script
            property pRead : false
            on |λ|()
                if pRead then
                    |λ|() of xs
                else
                    set pRead to true
                    return x
                end if
            end |λ|
        end script
    else
        x & xs
    end if
end cons
```