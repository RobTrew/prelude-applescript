```applescript
-- readBinary :: String -> Int
on readBinary(s)
    -- The integer value of the binary string s
    script go
        on |λ|(c, en)
            set {e, n} to en
            set v to ((id of c) - 48)
            
            {2 * e, v * e + n}
        end |λ|
    end script
    
    item 2 of foldr(go, {1, 0}, s)
end readBinary
```