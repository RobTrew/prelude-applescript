```applescript
-- delete :: Eq a => a -> [a] -> [a]
on |delete|(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs
    
    if Nothing of mbIndex then
        xs
    else
        if 1 < lng then
            set i to Just of mbIndex
            if 1 = i then
                items 2 thru -1 of xs
            else if lng = i then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (i - 1) & items (i + 1) thru -1
            end if
        else
            {}
        end if
    end if
end |delete|
```