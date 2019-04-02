```applescript
-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen
```