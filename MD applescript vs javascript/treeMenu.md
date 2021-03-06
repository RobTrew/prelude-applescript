```javascript
// treeMenu :: Tree String -> IO [String]
const treeMenu = tree => {
    const go = t => {
        const
            strTitle = t.root,
            subs = t.nest,
            menu = subs.map(root),
            blnMore = 0 < subs.flatMap(nest).length;

        return until(tpl => !fst(tpl) || !isNull(snd(tpl)))(
            tpl => either(
                x => Tuple(false)([])
            )(
                Tuple(true)
            )(
                bindLR(
                    showMenuLR(!blnMore)(strTitle)(menu)
                )(ks => {
                    const
                        k = ks[0],
                        msg = `${k}: not found in ${ks}`;

                    return maybe(
                        Left(msg)
                    )(Right)(
                        bindMay(
                            find(x => k === x.root)(
                                subs
                            )
                        )(
                            chosen => Just(
                                isNull(chosen.nest) ? (
                                    ks
                                ) : go(chosen)
                            )
                        )
                    );
                })
            )
        )(Tuple(true)([]))[1];
    };

    return go(tree);
};
```


```applescript
-- treeMenu :: Tree String -> IO [String]
on treeMenu(tree)
    script go
        on |λ|(tree)
            set menuTitle to root of tree
            set subTrees to nest of tree
            set menuItems to map(my root, subTrees)
            set blnNoSubMenus to {} = concatMap(my nest, subTrees)
            
            script menuCancelledOrChoiceMade
                on |λ|(statusAndChoices)
                    (not my fst(statusAndChoices)) or ({} ≠ my snd(statusAndChoices))
                end |λ|
            end script
            
            script choicesOrSubMenu
                on |λ|(choices)
                    set k to item 1 of choices
                    script match
                        on |λ|(x)
                            k = root of x
                        end |λ|
                    end script
                    set chosenSubTree to (Just of find(match, subTrees))
                    if {} ≠ (nest of chosenSubTree) then
                        |Right|(|λ|(chosenSubTree) of go)
                    else
                        |Right|(choices)
                    end if
                end |λ|
            end script
            
            script nothingFromThisMenu
                on |λ|(_)
                    Tuple(false, {})
                end |λ|
            end script
            
            script selectionsFromThisMenu
                on |λ|(xs)
                    Tuple(true, xs)
                end |λ|
            end script
            
            script nextStepInNestedMenu
                on |λ|(statusAndChoice)
                    either(nothingFromThisMenu, selectionsFromThisMenu, ¬
                        bindLR(showMenuLR(blnNoSubMenus, menuTitle, menuItems), ¬
                            choicesOrSubMenu))
                end |λ|
            end script
            
            snd(|until|(menuCancelledOrChoiceMade, ¬
                nextStepInNestedMenu, ¬
                Tuple(true, {}))) -- (Status, Choices) pair
        end |λ|
    end script
    |λ|(tree) of go
end treeMenu
```