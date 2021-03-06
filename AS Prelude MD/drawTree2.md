```applescript
-- drawTree2 :: Bool -> Bool -> Tree String -> String
on drawTree2(blnCompressed, blnPruned, tree)
    -- Tree design and algorithm inspired by the Haskell snippet at:
    -- https://doisinkidney.com/snippets/drawing-trees.html
    script measured
        on |λ|(t)
            script go
                on |λ|(x)
                    set s to " " & x & " "
                    Tuple(length of s, s)
                end |λ|
            end script
            fmapTree(go, t)
        end |λ|
    end script
    set measuredTree to |λ|(tree) of measured
    
    script levelMax
        on |λ|(a, level)
            a & maximum(map(my fst, level))
        end |λ|
    end script
    set levelWidths to foldl(levelMax, {}, ¬
        init(levels(measuredTree)))
    
    -- Lefts, Mid, Rights
    script lmrFromStrings
        on |λ|(xs)
            set {ls, rs} to items 2 thru -2 of ¬
                (splitAt((length of xs) div 2, xs) as list)
            Tuple3(ls, item 1 of rs, rest of rs)
        end |λ|
    end script
    
    script stringsFromLMR
        on |λ|(lmr)
            script add
                on |λ|(a, x)
                    a & x
                end |λ|
            end script
            foldl(add, {}, items 2 thru -2 of (lmr as list))
        end |λ|
    end script
    
    script fghOverLMR
        on |λ|(f, g, h)
            script
                property mg : mReturn(g)
                on |λ|(lmr)
                    set {ls, m, rs} to items 2 thru -2 of (lmr as list)
                    Tuple3(map(f, ls), |λ|(m) of mg, map(h, rs))
                end |λ|
            end script
        end |λ|
    end script
    
    script treeFix
        on cFix(x)
            script
                on |λ|(xs)
                    x & xs
                end |λ|
            end script
        end cFix
        
        on |λ|(l, m, r)
            compose(stringsFromLMR, ¬
                |λ|(cFix(l), cFix(m), cFix(r)) of ¬
                fghOverLMR)
        end |λ|
    end script

    script lmrBuild
        on leftPad(n)
            script
                on |λ|(s)
                    replicateString(n, space) & s
                end |λ|
            end script
        end leftPad
        
        -- lmrBuild main
        on |λ|(w, f)
            script
                property mf : mReturn(f)
                on |λ|(wsTree)
                    set xs to nest of wsTree
                    set lng to length of xs
                    set {nChars, x} to items 2 thru -2 of ¬
                        ((root of wsTree) as list)
                    set _x to replicateString(w - nChars, "─") & x
                    
                    script linked
                        on |λ|(s)
                            set c to text 1 of s
                            set t to tail(s)
                            if "┌" = c then
                                _x & "┬" & t
                            else if "│" = c then
                                _x & "┤" & t
                            else if "├" = c then
                                _x & "┼" & t
                            else
                                _x & "┴" & t
                            end if
                        end |λ|
                    end script
                    
                    -- LEAF NODE --------------------------------------
                    if 0 = lng then
                        Tuple3({}, _x, {})
                        
                    else if 1 = lng then
                        -- NODE WITH SINGLE CHILD ---------------------
                        set indented to leftPad(1 + w)
                        script lineLinked
                            on |λ|(z)
                                _x & "─" & z
                            end |λ|
                        end script
                        |λ|(|λ|(item 1 of xs) of mf) of ¬
                            (|λ|(indented, lineLinked, indented) of ¬
                                fghOverLMR)
                    else
                        -- NODE WITH CHILDREN -------------------------
                        set indented to leftPad(w)
                        set lmrs to map(f, xs)
                        if blnCompressed then
                            set sep to {}
                        else
                            set sep to {"│"}
                        end if
                        
                        tell lmrFromStrings
                            set tupleLMR to |λ|(intercalate(sep, ¬
                                {|λ|(item 1 of lmrs) of ¬
                                    (|λ|(" ", "┌", "│") of treeFix)} & ¬
                                map(|λ|("│", "├", "│") of treeFix, ¬
                                    init(tail(lmrs))) & ¬
                                {|λ|(item -1 of lmrs) of ¬
                                    (|λ|("│", "└", " ") of treeFix)}))
                        end tell
                        
                        |λ|(tupleLMR) of ¬
                            (|λ|(indented, linked, indented) of fghOverLMR)
                    end if
                end |λ|
            end script
        end |λ|
    end script
    
    set treeLines to |λ|(|λ|(measuredTree) of ¬
        foldr(lmrBuild, 0, levelWidths)) of stringsFromLMR
    if blnPruned then
        script notEmpty
            on |λ|(s)
                script isData
                    on |λ|(c)
                        "│ " does not contain c
                    end |λ|
                end script
                any(isData, characters of s)
            end |λ|
        end script
        set xs to filter(notEmpty, treeLines)
    else
        set xs to treeLines
    end if
    unlines(xs)
end drawTree2
```