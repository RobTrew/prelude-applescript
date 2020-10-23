```applescript
-- treeFromDict :: String -> Dict -> Tree String
on treeFromDict(treeTitle, recDict)
    script go
        on |λ|(x)
            set c to class of x
            if list is c then
                script
                    on |λ|(v)
                        Node(v, {})
                    end |λ|
                end script
                map(result, x)
            else if record is c then
                script
                    on |λ|(k)
                        Node(k, go's |λ|(|Just| of lookupDict(k, x)))
                    end |λ|
                end script
                map(result, keys(x))
            else
                {}
            end if
        end |λ|
    end script
    Node(treeTitle, go's |λ|(recDict))
end treeFromDict
```