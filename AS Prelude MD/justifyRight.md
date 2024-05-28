```applescript
-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(txt)
            if n > length of txt then
                text -n thru -1 of ((replicate(n, cFiller) as text) & txt)
            else
                txt
            end if
        end |λ|
    end script
end justifyRight
```