```applescript
-- filterGen :: (a -> Bool) -> Gen [a] -> Gen [a]
on filterGen(p, gen)
    -- Non-finite stream of values which are 
    -- drawn from gen, and satisfy p
    script
        property mp : mReturn(p)'s |λ|
        on |λ|()
            set v to gen's |λ|()
            repeat until mp(v)
                set v to gen's |λ|()
            end repeat
            return v
        end |λ|
    end script
end filterGen
```