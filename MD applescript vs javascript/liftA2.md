```javascript
// liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
const liftA2 = f =>
    // Lift a binary function to actions.
    // liftA2 f a b = fmap f a <*> b
    a => b => ({
        "(a -> b)": () => liftA2Fn,
        "Either": () => liftA2LR,
        "Maybe": () => liftA2May,
        "Tuple": () => liftA2Tuple,
        "Node": () => liftA2Tree,
        "List": () => liftA2List,
        "Bottom": () => liftA2List
    }[typeName(a) || "List"]())(f)(a)(b);
```


```applescript
-- liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
on liftA2(f, a, b)
    -- Lift a binary function to actions.
    -- e.g.
    -- liftA2(mult, {1, 2, 3}, {4, 5, 6}) 
    --> {4, 5, 6, 8, 10, 12, 12, 15, 18}
    set c to class of a
    if c is list or c is text then
        liftA2List(f, a, b)
    else
        set t to typeName(a)
        if "(a -> b)" = t then
            liftA2Fn(f, a, b)
        else if "Either" = t then
            liftA2LR(f, a, b)
        else if "Maybe" = t then
            liftA2May(f, a, b)
        else if "Tuple" = t then
            liftA2Tuple(f, a, b)
        else if "Node" = t then
            liftA2Tree(f, a, b)
        else
            missing value
        end if
    end if
end liftA2
```