```applescript
-- draw :: Tree String -> [String]
on draw(tree)
    
    -- shift :: String -> String -> [String] -> [String]
    script shift
        on |λ|(strFirst, strOther, xs)
            zipWith(my append, ¬
                cons(strFirst, replicate((length of xs) - 1, strOther)), xs)
        end |λ|
    end script
    
    -- drawSubTrees :: [Tree String] -> [String]
    script drawSubTrees
        on |λ|(xs)
            set lng to length of xs
            if 0 < lng then
                if 1 < lng then
                    cons("│", append(shift's |λ|("├─ ", "│  ", draw(item 1 of xs)), ¬
                        |λ|(items 2 thru -1 of xs)))
                else
                    cons("│", shift's |λ|("└─ ", "   ", draw(item 1 of xs)))
                end if
            else
                {}
            end if
        end |λ|
    end script
    
    paragraphs of (root of tree) & |λ|(nest of tree) of drawSubTrees
end draw
```