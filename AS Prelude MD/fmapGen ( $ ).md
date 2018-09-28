```applescript
-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : gen
        property mf : mReturn(f)'s |λ|
        on |λ|()
            set v to g's |λ|()
            if v is missing value then
                v
            else
                mf(v)
            end if
        end |λ|
    end script
end fmapGen
```