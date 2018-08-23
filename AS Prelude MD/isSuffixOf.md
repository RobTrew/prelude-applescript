```applescript
-- isSuffixOf :: Eq a => [a] -> [a] -> Bool
on isSuffixOf(ns, hs)
    script go
        on |λ|(delta)
            ns = dropLength(delta, hs)
        end |λ|
    end script
    bindMay(dropLengthMaybe(ns, hs), go)
end isSuffixOf
```