```applescript
-- Action :: (a -> b) -> a -> Action b
on Action(f, x)
    -- Constructor for an action.
    {type:"Action", act:f, arg:x}
end Action
```


```javascript
// Action :: (a -> b) -> a -> Action b
const Action = f =>
    // Constructor for an action.
    x => ({
        type: 'Action',
        act: f,
        arg: x
    });
```