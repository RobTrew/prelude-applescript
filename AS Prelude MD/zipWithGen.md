```applescript
-- zipWithGen :: (a -> b -> c) -> Gen [a] -> Gen [b] -> Gen [c]
on zipWithGen(f, ga, gb)
    script
        property ma : missing value
        property mb : missing value
        property mf : mReturn(f)
        on |λ|()
            if missing value is ma then
                set ma to uncons(ga)
                set mb to uncons(gb)
            end if
            if Nothing of ma or Nothing of mb then
                missing value
            else
                set ta to Just of ma
                set tb to Just of mb
                set ma to uncons(|2| of ta)
                set mb to uncons(|2| of tb)
                |λ|(|1| of ta, |1| of tb) of mf
            end if
        end |λ|
    end script
end zipWithGen
```