```applescript
-- splitOn("\r\n", "a\r\nb\r\nd\r\ne") --> ["a","b","d","e"]
-- splitOn("aaa", "aaaXaaaXaaaXaaa") --> {"", "X", "X", "X", ""}
-- splitOn("x", "x") --> {"", ""}
-- splitOn(5, {1, 5, 9, 2, 6, 5, 3, 5}) --> {{1}, {9, 2, 6}, {3}, {}}
```

```applescript
-- splitOn :: a -> [a] -> [[a]]
-- splitOn :: String -> String -> [String]
on splitOn(needle, haystack)
    if class of haystack is text then
        set {dlm, my text item delimiters} to ¬
            {my text item delimiters, needle}
        set xs to text items of haystack
        set my text item delimiters to dlm
        return xs
    else
        script triage
            on |λ|(a, x)
                if needle = x then
                    Tuple(|1| of a & {|2| of a}, {})
                else
                    Tuple(|1| of a, (|2| of a) & x)
                end if
            end |λ|
        end script
        
        set tpl to foldl(triage, Tuple({}, {}), haystack)
        return |1| of tpl & {|2| of tpl}
    end if
end splitOn
```