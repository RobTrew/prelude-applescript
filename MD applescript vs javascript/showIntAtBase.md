```javascript
// showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
const showIntAtBase = base =>
    toChr => n => rs => {
        const go = ([x, d], r) => {
            const r_ = toChr(d) + r;

            return 0 !== x ? (
                go(Array.from(quotRem(n)(base)), r_)
            ) : r_;
        };

        return 1 >= base ? (
            "error: showIntAtBase applied to unsupported base"
        ) : 0 > n ? (
            "error: showIntAtBase applied to negative number"
        ) : go(Array.from(quotRem(n)(base)), rs);
    };
```


```applescript
-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script go
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to nd_
            set r_ to f's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    |λ|(quotRem(n, base), rs) of go
end showIntAtBase
```