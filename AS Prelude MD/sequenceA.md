```applescript
-- sequenceA :: (Applicative f, Traversable t) => t (f a) -> f (t a)
on sequenceA(tfa)
    script identity
        on |λ|(x)
            x
        end |λ|
    end script
    traverse(identity, tfa)
end sequenceA
```