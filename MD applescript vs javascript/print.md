```javascript
// print :: a -> IO ()
const print = x => {
    const s = show(x);

    return (
        typeof document !== "undefined" ? (
            document.writeln(s)
        ) : typeof draft !== "undefined" ? (
            editor.setText(
                `${editor.getText()}\n${s}`
            )
        ) : (
            // eslint-disable-next-line no-console
            console.log(s),
            s
        )
    );
};
```


```applescript
-- print :: a -> IO ()
on print (x)
    log x
    return x
end print
```