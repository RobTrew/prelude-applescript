```javascript
// ap (<*>) :: Monad m => m (a -> b) -> m a -> m b
const ap = mf =>
    // Applies wrapped functions to wrapped values,
    // for example applying a list of functions to a list of values
    // or applying Just(f) to Just(x), Right(f) to Right(x), 
    // f(x) to g(x) etc.
    mx => {
        const t = mx.type;
        return (
            undefined !== t ? (
                'Either' === t ? (
                    apLR
                ) : 'Maybe' === t ? (
                    apMay
                ) : 'Node' === t ? (
                    apTree
                ) : 'Tuple' === t ? (
                    apTuple
                ) : apList
            ) : Array.isArray(mf) ? (
                apList
            ) : apFn
        )(mf)(mx);
    };
```


```applescript
-- Applies wrapped functions to wrapped values, 
-- for example applying a list of functions to a list of values
-- or applying Just(f) to Just(x), Right(f) to Right(x), etc
-- ap (<*>) :: Monad m => m (a -> b) -> m a -> m b
on ap(mf, mx)
    if class of mx is list then
        apList(mf, mx)
    else
        set t to typeName(mf)
        if "(a -> b)" = t then
            apFn(mf, mx)
        else if "Either" = t then
            apLR(mf, mx)
        else if "Maybe" = t then
            apMay(mf, mx)
        else if "Node" = t then
            apTree(mf, mx)
        else if "Tuple" = t then
            apTuple(mf, mx)
        else
            missing value
        end if
    end if
end ap
```