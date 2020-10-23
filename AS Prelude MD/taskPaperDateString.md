```applescript
-- taskPaperDateString :: Date -> String
on taskPaperDateString(dte)
    set {d, t} to splitOn("T", dte as «class isot» as string)
    d & space & text 1 thru 5 of t
end taskPaperDateString
```