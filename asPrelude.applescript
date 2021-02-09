use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

-- Just :: a -> Maybe a
on Just(x)
    -- Constructor for an inhabited Maybe (option type) value.
    -- Wrapper containing the result of a computation.
    {type:"Maybe", Nothing:false, Just:x}
end Just

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|

-- Node :: a -> [Tree a] -> Tree a
on Node(v, xs)
    {type:"Node", root:v, nest:xs}
end Node

-- Nothing :: Maybe a
on Nothing()
    -- Constructor for an empty Maybe (option type) value.
    -- Empty wrapper returned where a computation is not possible.
    {type: "Maybe", Nothing: true}
end Nothing

-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    -- Constructor for a pair of values, possibly of two different types.
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple

-- Tuple3 (,,) :: a -> b -> c -> (a, b, c)
on Tuple3(x, y, z)
    {type:"Tuple3", |1|:x, |2|:y, |3|:z, length:3}
end Tuple3

-- Requires N arguments to be wrapped as one list in AS 
-- (the JS version accepts N separate arguments)
-- TupleN :: a -> b ...  -> (a, b ... )
on TupleN(argv)
    tupleFromList(argv)
end TupleN

-- abs :: Num -> Num
on abs(x)
    -- Absolute value.
    if 0 > x then
        -x
    else
        x
    end if
end abs

-- add (+) :: Num a => a -> a -> a
on add(a)
    -- Curried addition.
    script
        on |λ|(b)
            a + b
        end |λ|
    end script
end add

-- all :: (a -> Bool) -> [a] -> Bool
on all(p, xs)
    -- True if p holds for every value in xs
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if not |λ|(item i of xs, i, xs) then return false
        end repeat
        true
    end tell
end all

-- allSame :: [a] -> Bool
on allSame(xs)
    if 2 > length of xs then
        true
    else
        script p
            property h : item 1 of xs
            on |λ|(x)
                h = x
            end |λ|
        end script
        all(p, rest of xs)
    end if
end allSame

-- allTree :: (a -> Bool) -> Tree a -> Bool
on allTree(p, tree)
    -- True if p holds for the value of every node in tree
    script go
        property mp : mReturn(p)'s |λ|
        on |λ|(oNode)
            if mp(root of oNode) then
                repeat with v in nest of oNode
                    if not (contents of |λ|(v)) then return false
                end repeat
                true
            else
                false
            end if
        end |λ|
    end script
    |λ|(tree) of go
end allTree

-- and :: [Bool] -> Bool
on |and|(xs)
    -- True if every value in the list is true.
    repeat with x in xs
        if not (contents of x) then return false
    end repeat
    return true
end |and|

-- any :: (a -> Bool) -> [a] -> Bool
on any(p, xs)
    -- Applied to a predicate and a list, 
    -- |any| returns true if at least one element of the 
    -- list satisfies the predicate.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return true
        end repeat
        false
    end tell
end any

-- anyTree :: (a -> Bool) -> Tree a -> Bool
on anyTree(p, tree)
    -- True if p holds for the value of any node in the tree.
    script go
        property mp : mReturn(p)'s |λ|
        on |λ|(oNode)
            if mp(root of oNode) then
                true
            else
                repeat with v in nest of oNode
                    if contents of |λ|(v) then return true
                end repeat
                false
            end if
        end |λ|
    end script
    |λ|(tree) of go
end anyTree

-- ap (<*>) :: Monad m => m (a -> b) -> m a -> m b
on ap(mf, mx)
    -- Applies wrapped functions to wrapped values, 
    -- for example applying a list of functions to a list of values
    -- or applying Just(f) to Just(x), Right(f) to Right(x), etc
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

-- apFn :: (a -> b -> c) -> (a -> b) -> (a -> c)
on apFn(f, g)
    script go
        property mf : |λ| of mReturn(f)
        property mg : |λ| of mReturn(g)
        on |λ|(x)
            mf(x, mg(x))
        end |λ|
    end script
end apFn

-- apLR (<*>) :: Either e (a -> b) -> Either e a -> Either e b
on apLR(flr, lr)
    if missing value is |Left| of flr then
        if missing value is |Left| of lr then
            |Right|(|λ|(|Right| of lr) of mReturn(|Right| of flr))
        else
            lr
        end if
    else
        flr
    end if
end apLR

-- apList (<*>) :: [(a -> b)] -> [a] -> [b]
on apList(fs, xs)
    -- e.g. [(*2),(/2), sqrt] <*> [1,2,3]
    -- -->  ap([dbl, hlf, root], [1, 2, 3])
    -- -->  [2,4,6,0.5,1,1.5,1,1.4142135623730951,1.7320508075688772]
    -- Each member of a list of functions applied to
    -- each of a list of arguments, deriving a list of new values
    set lst to {}
    repeat with f in fs
        tell mReturn(contents of f)
            repeat with x in xs
                set end of lst to |λ|(contents of x)
            end repeat
        end tell
    end repeat
    return lst
end apList

-- apMay (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
on apMay(mf, mx)
    -- Maybe f applied to Maybe x, deriving a Maybe y
    if Nothing of mf or Nothing of mx then
        Nothing()
    else
        Just(|λ|(Just of mx) of mReturn(Just of mf))
    end if
end apMay

-- apTree (<*>) :: Tree (a -> b) -> Tree a -> Tree b
on apTree(tf, tx)
    set fmap to curry(my fmapTree)
    script go
        on |λ|(t)
            set f to root of t
            Node(mReturn(f)'s |λ|(root of tx), ¬
                map(fmap's |λ|(f), nest of tx) & ¬
                map(go, nest of t))
        end |λ|
    end script
    
    return go's |λ|(tf)
end apTree

-- apTuple (<*>) :: Monoid m => (m, (a -> b)) -> (m, a) -> (m, b)
on apTuple(tf, tx)
    Tuple(mappend(|1| of tf, |1| of tx), |λ|(|2| of tx) of mReturn(|2| of tf))
end apTuple

-- append (<>) :: [a] -> [a] -> [a]
-- append (<>) :: String -> String -> String
on append(xs, ys)
    -- Append two lists.
    xs & ys
end append

-- appendFile :: FilePath -> String -> IO Bool
on appendFile(strPath, txt)
    -- Write a string to the end of a file. 
    -- Returns true if the path exists 
    -- and the write succeeded. 
    -- Otherwise returns false.
    set ca to current application
    set oFullPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {blnExists, intFolder} to (ca's NSFileManager's defaultManager()'s ¬
        fileExistsAtPath:oFullPath isDirectory:(reference))
    if blnExists then
        if 0 = intFolder then
            set oData to (ca's NSString's stringWithString:txt)'s ¬
                dataUsingEncoding:(ca's NSUTF8StringEncoding)
            set h to ca's NSFileHandle's fileHandleForWritingAtPath:oFullPath
            h's seekToEndOfFile
            h's writeData:oData
            h's closeFile()
            true
        else
            -- text appended to folder is undefined
            false
        end if
    else
        if doesDirectoryExist(takeDirectory(oFullPath as string)) then
            writeFile(oFullPath, txt)
            true
        else
            false
        end if
    end if
end appendFile

-- appendFileMay :: FilePath -> String -> Maybe IO FilePath
on appendFileMay(strPath, txt)
    -- Write a string to the end of a file. 
    -- Returns a Just FilePath value if the 
    -- path exists and the write succeeded. 
    -- Otherwise returns Nothing.
    set ca to current application
    set oFullPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set strFullPath to oFullPath as string
    set {blnExists, intFolder} to (ca's NSFileManager's defaultManager()'s ¬
        fileExistsAtPath:oFullPath isDirectory:(reference))
    if blnExists then
        if 0 = intFolder then -- Not a directory
            set oData to (ca's NSString's stringWithString:txt)'s ¬
                dataUsingEncoding:(ca's NSUTF8StringEncoding)
            set h to ca's NSFileHandle's fileHandleForWritingAtPath:oFullPath
            h's seekToEndOfFile
            h's writeData:oData
            h's closeFile()
            Just(strFullPath)
        else
            Nothing()
        end if
    else
        if doesDirectoryExist(takeDirectory(strFullPath)) then
            writeFile(oFullPath, txt)
            Just(strFullPath)
        else
            Nothing()
        end if
    end if
end appendFileMay

-- appendGen (++) :: Gen [a] -> Gen [a] -> Gen [a]
on appendGen(xs, ys)
    script
        property vs : xs
        on |λ|()
            set v to |λ|() of vs
            if missing value is not v then
                v
            else
                set vs to ys
                |λ|() of ys
            end if
        end |λ|
    end script
end appendGen

-- apply ($) :: (a -> b) -> a -> b
on apply(f, x)
    mReturn(f)'s |λ|(x)
end apply

-- applyN :: Int -> (a -> a) -> a -> a
on applyN(n, f, x)
    script go
        on |λ|(a, g)
            |λ|(a) of mReturn(g)
        end |λ|
    end script
    foldl(go, x, replicate(n, f))
end applyN

-- approxRatio :: Float -> Float -> Ratio
on approxRatio(epsilon, n)
    if {real, integer} contains (class of epsilon) and 0 < epsilon then
        set e to epsilon
    else
        set e to 1 / 10000
    end if
    
    script gcde
        on |λ|(e, x, y)
            script _gcd
                on |λ|(a, b)
                    if b < e then
                        a
                    else
                        |λ|(b, a mod b)
                    end if
                end |λ|
            end script
            |λ|(abs(x), abs(y)) of _gcd
        end |λ|
    end script
    
    set c to |λ|(e, 1, n) of gcde
    Ratio((n div c), (1 div c))
end approxRatio

-- argvLength :: Function -> Int
on argvLength(h)
    try
        mReturn(h)'s |λ|()
        0
    on error errMsg
        set {dlm, my text item delimiters} to {my text item delimiters, ","}
        set xs to text items of errMsg
        set my text item delimiters to dlm
        length of xs
    end try
end argvLength

-- assocs :: Map k a -> [(k, a)]
on assocs(m)
    script go
        on |λ|(k)
            set mb to lookupDict(k, m)
            if true = |Nothing| of mb then
                {}
            else
                {{k, |Just| of mb}}
            end if
        end |λ|
    end script
    concatMap(go, keys(m))
end assocs

-- base64decode :: String -> String
on base64decode(s)
    tell current application
        set encoding to its NSUTF8StringEncoding
        set ignore to its NSDataBase64DecodingIgnoreUnknownCharacters
        
        (((alloc() of its NSString)'s initWithData:((its (NSData's alloc()'s ¬
            initWithBase64EncodedString:s ¬
                options:(ignore)))) encoding:ignore)) as text
    end tell
end base64decode

-- base64encode :: String -> String
on base64encode(s)
    tell current application
        set encodingOption to its NSUTF8StringEncoding
        base64EncodedStringWithOptions_(0) of ¬
            dataUsingEncoding_(encodingOption) of ¬
            (stringWithString_(s) of its NSString) as string
    end tell
end base64encode

-- bimap :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
on bimap(f, g)
    -- Tuple instance of bimap.
    -- A tuple of the application of f and g to the
    -- first and second values of tpl respectively.
    script
        on |λ|(x)
            {|λ|(fst(x)) of mReturn(f), ¬
                |λ|(snd(x)) of mReturn(g)}
        end |λ|
    end script
end bimap

-- bimapLR :: (a -> b) -> (c -> d) -> ֵEither ֵֵa c -> Either b d
on bimapLR(f, g)
    script go
        on |λ|(e)
            if missing value is |Left| of e then
                tell mReturn(g) to |Right|(|λ|(|Right| of e))
            else
                tell mReturn(f) to |Left|(|λ|(|Left| of e))
            end if
        end |λ|
    end script
end bimapLR

-- bimapN :: (a -> b) -> (c -> d) -> TupleN -> TupleN
on bimapN(f, g, tplN)
    set z to length of tplN
    set k1 to (z - 1) as string
    set k2 to z as string
    
    insertDict(k2, mReturn(g)'s |λ|(Just of lookupDict(k2, tplN)), ¬
        insertDict(k1, mReturn(f)'s |λ|(Just of lookupDict(k1, tplN)), tplN))
end bimapN

-- bind (>>=) :: Monad m => m a -> (a -> m b) -> m b
on bind(m, mf)
    set c to class of m
    if list = c then
        bindList(m, mf)
    else if record = c then
        set ks to keys(m)
        if ks contains "type" then
            set t to type of m
            if "Maybe" = t then
                bindMay(m, mf)
            else if "Either" = t then
                bindLR(m, mf)
            else if "Tuple" = t then
                bindTuple(m, mf)
            else
                missing value
            end if
        else
            missing value
        end if
    else if handler is c or script is c then
        bindFn(m, mf)
    else
        missing value
    end if
end bind

-- bindFn (>>=) :: (a -> b) -> (b -> a -> c) -> a -> c
on bindFn(f, bop)
    -- Where either bop or f is a  binary operator.
    script
        property mf : mReturn(f)
        property mop : mReturn(bop)
        on |λ|(x)
            try
                curry(mop)'s |λ|(mf's |λ|(x))'s |λ|(x)
            on error
                mop's |λ|(curry(mf)'s |λ|(x))'s |λ|(x)
            end try
        end |λ|
    end script
end bindFn

-- bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
on bindLR(m, mf)
    if missing value is not |Left| of m then
        m
    else
        mReturn(mf)'s |λ|(|Right| of m)
    end if
end bindLR

-- bindList (>>=) :: [a] -> (a -> [b]) -> [b]
on bindList(xs, f)
    set acc to {}
    tell mReturn(f)
        repeat with x in xs
            set acc to acc & |λ|(contents of x)
        end repeat
    end tell
    return acc
end bindList

-- bindMay (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
on bindMay(mb, mf)
    -- bindMay provides the mechanism for composing a
    -- sequence of (a -> Maybe b) functions.
    -- If m is Nothing, it is passed straight through.
    -- If m is Just(x), the result is an application
    -- of the (a -> Maybe b) function (mf) to x.
    if Nothing of mb then
        mb
    else
        tell mReturn(mf) to |λ|(Just of mb)
    end if
end bindMay

-- bindTuple (>>=) :: Monoid a => (a, a) -> (a -> (a, b)) -> (a, b)
on bindTuple(tpl, f)
    set t2 to mReturn(f)'s |λ|(|2| of tpl)
    Tuple(mappend(|1| of tpl, |1| of t2), |2| of t2)
end bindTuple

-- bool :: a -> a -> Bool -> a
on bool(ff, tf)
    -- The evaluation of either tf or ff, 
    -- depending on a boolean value.
    script
        on |λ|(bln)
            if bln then
                set e to tf
            else
                set e to ff
            end if
            set c to class of e
            if {script, handler} contains c then
                |λ|() of mReturn(e)
            else
                e
            end if
        end |λ|
    end script
end bool

-- break :: (a -> Bool) -> [a] -> ([a], [a])
on break(p, xs)
    set bln to false
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then
                set bln to true
                exit repeat
            end if
        end repeat
    end tell
    if bln then
        if 1 < i then
            {items 1 thru (i - 1) of xs, items i thru -1 of xs}
        else
            {{}, xs}
        end if
    else
        {xs, {}}
    end if
end break

-- breakOn :: String -> String -> (String, String)
on breakOn(pat, src)
    -- non null needle -> haystack -> (prefix before match, match + rest)
    if pat ≠ "" then
        set {dlm, my text item delimiters} to {my text item delimiters, pat}
        
        set lstParts to text items of src
        set lngParts to length of lstParts
        
        if 1 < lngParts then
            set tpl to {item 1 of lstParts, pat & ¬
                ((items 2 thru -1 of lstParts) as text)}
        else
            set tpl to Tuple(src, "")
        end if
        
        set my text item delimiters to dlm
        return tpl
    else
        missing value
    end if
end breakOn

-- breakOnAll :: String -> String -> [(String, String)]
on breakOnAll(pat, src)
    -- breakOnAll "/" "a/b/c/"
    -- ==> [("a", "/b/c/"), ("a/b", "/c/"), ("a/b/c", "/")]
    if "" ≠ pat then
        script
            on |λ|(a, _, i, xs)
                if 1 < i then
                    a & {{intercalate(pat, take(i - 1, xs)), ¬
                        pat & intercalate(pat, drop(i - 1, xs))}}
                else
                    a
                end if
            end |λ|
        end script
        foldl(result, {}, splitOn(pat, src))
    else
        missing value
    end if
end breakOnAll

-- breakOnMay :: String -> String -> Maybe (String, String)
on breakOnMay(pat, src)
    -- needle -> haystack -> maybe (prefix before match, match + rest)
    if pat ≠ "" then
        set {dlm, my text item delimiters} to {my text item delimiters, pat}
        
        set lstParts to text items of src
        if length of lstParts > 1 then
            set mbTuple to Just({item 1 of lstParts, pat & ¬
                ((items 2 thru -1 of lstParts) as text)})
        else
            set mbTuple to Just({src, ""})
        end if
        
        set my text item delimiters to dlm
        return mbTuple
    else
        Nothing()
    end if
end breakOnMay

-- bulleted :: String -> String -> String
on bulleted(strIndent, s)
    script go
        on |λ|(x)
            if "" ≠ x then
                strIndent & "- " & x
            else
                x
            end if
        end |λ|
    end script
    unlines(map(go, paragraphs of s))
end bulleted

-- cartesianProduct :: [a] -> [b] -> [[a, b]]
on cartesianProduct(xs, ys)
    script
        on |λ|(x)
            script
                on |λ|(y)
                    {x, y}
                end |λ|
            end script
            concatMap(result, ys)
        end |λ|
    end script
    concatMap(result, xs)
end cartesianProduct

-- caseOf :: [(a -> Bool, b)] -> b -> a ->  b
on caseOf (pvs, otherwise, x)
    -- List of (Predicate, value) tuples -> Default value -> Value to test -> Output value
    repeat with tpl in pvs
        if mReturn(|1| of tpl)'s |λ|(x) then return |2| of tpl
    end repeat
    return otherwise
end caseOf

-- catMaybes :: [Maybe a] -> [a]
on catMaybes(mbs)
    script emptyOrListed
        on |λ|(m)
            if Nothing of m then
                {}
            else
                {Just of m}
            end if
        end |λ|
    end script
    concatMap(emptyOrListed, mbs)
end catMaybes

-- ceiling :: Num -> Int
on ceiling(x)
    set nr to properFraction(x)
    set n to |1| of nr
    if 0 < (|2| of nr) then
        n + 1
    else
        n
    end if
end ceiling

-- center :: Int -> Char -> String -> String
on |center|(n, cFiller, strText)
    set lngFill to n - (length of strText)
    if lngFill > 0 then
        set strPad to replicate(lngFill div 2, cFiller) as text
        set strCenter to strPad & strText & strPad
        if lngFill mod 2 > 0 then
            cFiller & strCenter
        else
            strCenter
        end if
    else
        strText
    end if
end |center|

-- chars :: String -> [Char]
on chars(s)
    characters of s
end chars

-- chop :: ([a] -> (b, [a])) -> [a] -> [b]
on chop(f, xs)
    script go
        property g : mReturn(f)
        on |λ|(xs)
            if 0 < length of xs then
                set {b, ys} to g's |λ|(xs)
                {b} & |λ|(ys)
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end chop

-- chr :: Int -> Char
on chr(n)
    character id n
end chr

-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to item 1 of ab
            if {} ≠ a then
                {a} & go(item 2 of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf

-- combine (</>) :: FilePath -> FilePath -> FilePath
on combine(fp, fp1)
    -- The concatenation of two filePath segments,
    -- without omission or duplication of "/".
    if "" = fp or "" = fp1 then
        fp & fp1
    else if "/" = item 1 of fp1 then
        fp1
    else if "/" = item -1 of fp then
        fp & fp1
    else
        fp & "/" & fp1
    end if
end combine

-- compare :: a -> a -> Ordering
on compare(a, b)
    if a < b then
        -1
    else if a > b then
        1
    else
        0
    end if
end compare

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f)
                set fa to |λ|(a)
                set fb to |λ|(b)
                if fa < fb then
                    -1
                else if fa > fb then
                    1
                else
                    0
                end if
            end tell
        end |λ|
    end script
end comparing

-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose

-- composeList :: [(a -> a)] -> (a -> a)
on composeList(fs)
    script
        on |λ|(x)
            script go
                on |λ|(f, a)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script
            foldr(go, x, fs)
        end |λ|
    end script
end composeList

-- composeListR :: [(a -> a)] -> (a -> a)
on composeListR(fs)
    script
        on |λ|(x)
            script go
                on |λ|(a, f)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script
            
            foldl(go, x, fs)
        end |λ|
    end script
end composeListLR

-- composeR (>>>) :: (a -> b) -> (b -> c) -> a -> c
on composeR(f, g)
    script
        on |λ|(x)
            |λ|(|λ|(x) of mReturn(f)) of mReturn(g)
        end |λ|
    end script
end composeR

-- concat :: [[a]] -> [a]
-- concat :: [String] -> String
on concat(xs)
    set lng to length of xs
    if 0 < lng and string is class of (item 1 of xs) then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    if {text, string} contains class of xs then
        acc as text
    else
        acc
    end if
end concatMap

-- cons :: a -> [a] -> [a]
on cons(x, xs)
    set c to class of xs
    if list is c then
        {x} & xs
    else if script is c then
        script
            property pRead : false
            on |λ|()
                if pRead then
                    |λ|() of xs
                else
                    set pRead to true
                    return x
                end if
            end |λ|
        end script
    else
        x & xs
    end if
end cons

-- constant :: a -> b -> a
on |constant|(k)
    script
        on |λ|(_)
            k
        end |λ|
    end script
end |constant|

-- createDirectoryIfMissingLR :: Bool -> FilePath -> Either String FilePath
on createDirectoryIfMissingLR(blnParents, fp)
    if doesPathExist(fp) then
        |Right|(fp)
    else
        set e to reference
        set ca to current application
        set oPath to (ca's NSString's stringWithString:(fp))'s ¬
            stringByStandardizingPath
        set {blnOK, e} to ca's NSFileManager's ¬
            defaultManager's createDirectoryAtPath:(oPath) ¬
            withIntermediateDirectories:(blnParents) ¬
            attributes:(missing value) |error|:(e)
        if blnOK then
            |Right|(fp)
        else
            |Left|((localizedDescription of e) as string)
        end if
    end if
end createDirectoryIfMissingLR

-- curry :: ((a, b) -> c) -> a -> b -> c
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry

-- cycle :: [a] -> Generator [a]
on cycle(xs)
    script
        property lng : 1 + (length of xs)
        property i : missing value
        on |λ|()
            if missing value is i then
                set i to 1
            else
                set nxt to (1 + i) mod lng
                if 0 = ((1 + i) mod lng) then
                    set i to 1
                else
                    set i to nxt
                end if
            end if
            return item i of xs
        end |λ|
    end script
end cycle

-- decodedPath :: Percent Encoded String -> FilePath
on decodedPath(fp)
    -- use framework "Foundation"
    tell current application to ¬
        (stringByRemovingPercentEncoding ¬
            of stringWithString_(fp) ¬
            of its NSString) as string
end decodedPath

-- degrees :: Float x => Radians x -> Degrees x
on degrees(r)
    (180 / pi) * r
end degrees

-- delete :: Eq a => a -> [a] -> [a]
on |delete|(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs
    
    if Nothing of mbIndex then
        xs
    else
        if 1 < lng then
            set i to Just of mbIndex
            if 1 = i then
                items 2 thru -1 of xs
            else if lng = i then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (i - 1) & items (i + 1) thru -1
            end if
        else
            {}
        end if
    end if
end |delete|

-- deleteAt :: Int -> [a] -> [a]
on deleteAt(i, xs)
    set lr to splitAt(i, xs)
    set {l, r} to {|1| of lr, |2| of lr}
    if 1 < length of r then
        l & items 2 thru -1 of r
    else
        l
    end if
end deleteAt

-- deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
on deleteBy(fnEq, x, xs)
    script go
        property eq : mReturn(fnEq)'s |λ|
        on |λ|(xs)
            if 0 < length of xs then
                tell xs to set {h, t} to {item 1, rest}
                if eq(x, h) then
                    t
                else
                    {h} & |λ|(t)
                end if
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end deleteBy

-- deleteFirst :: a -> [a] -> [a]
on deleteFirst(x, xs)
    script go
        on |λ|(xs)
            if 0 < length of xs then
                tell xs to set {h, t} to {item 1, rest}
                if x = h then
                    t
                else
                    {h} & |λ|(t)
                end if
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end deleteFirst

-- deleteFirstsBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
on deleteFirstsBy(fnEq, xs, ys)
    script
        on |λ|(x, y)
            deleteBy(fnEq, y, x)
        end |λ|
    end script
    foldl(result, xs, ys)
end deleteFirstsBy

-- deleteKey :: String -> Dict -> Dict
on deleteKey(k, rec)
    tell current application to set nsDct to ¬
        dictionaryWithDictionary_(rec) of its NSMutableDictionary
    removeObjectForKey_(k) of nsDct
    nsDct as record
end deleteKey

-- dictFromList :: [(k, v)] -> Dict
on dictFromList(kvs)
    set tpl to unzip(kvs)
    script go
        on |λ|(x)
            x as string
        end |λ|
    end script
    tell current application
        (its (NSDictionary's dictionaryWithObjects:(my snd(tpl)) ¬
            forKeys:(my map(go, my fst(tpl))))) as record
    end tell
end dictFromList

-- difference :: Eq a => [a] -> [a] -> [a]
on difference(xs, ys)
    script p
        on |λ|(x)
            x is not in ys
        end |λ|
    end script
    filter(p, xs)
end difference

-- differenceGen :: Gen [a] -> Gen [a] -> Gen [a]
on differenceGen(ga, gb)
    -- All values of ga except any
    -- already seen in gb.
    script
        property g : zipGen(ga, gb)
        property bs : {}
        property xy : missing value
        on |λ|()
            set xy to g's |λ|()
            if missing value is xy then
                xy
            else
                set x to |1| of xy
                set y to |2| of xy
                set bs to {y} & bs
                if bs contains x then
                    |λ|() -- Next in series.
                else
                    x
                end if
            end if
        end |λ|
    end script
end differenceGen

-- digitToInt :: Char -> Int
on digitToInt(c)
    set oc to id of c
    if 48 > oc or 102 < oc then
        missing value
    else
        set dec to oc - (id of "0")
        set hexu to oc - (id of "A")
        set hexl to oc - (id of "a")
        if 9 ≥ dec then
            dec
        else if 0 ≤ hexu and 5 ≥ hexu then
            10 + hexu
        else if 0 ≤ hexl and 5 ≥ hexl then
            10 + hexl
        else
            missing value
        end if
    end if
end digitToInt

-- div :: Int -> Int -> Int
on |div|(a, b)
    set v to (a / b)
    set i to round (v)
    if 0 < (i - v) then
        i - 1
    else
        i
    end if
end |div|

-- divMod :: Int -> Int -> (Int, Int)
on divMod(n, d)
    -- Integer division, truncated toward negative infinity,
    -- and integer modulus such that:
    -- (x `div` y)*y + (x `mod` y) == x
    set {q, r} to {n div d, n mod d}
    if signum(r) = signum(-d) then
        {q - 1, r + d}
    else
        {q, r}
    end if
end divMod

-- doesDirectoryExist :: FilePath -> IO Boolon doesDirectoryExist(strPath)    set ca to current application    set oPath to (ca's NSString's stringWithString:strPath)'s ¬        stringByStandardizingPath    set {bln, v} to (ca's NSFileManager's defaultManager's ¬        fileExistsAtPath:oPath isDirectory:(reference))    bln and vend doesDirectoryExist

-- doesFileExist :: FilePath -> IO Bool
on doesFileExist(strPath)
    set ca to current application
    set oPath to (ca's NSString's stringWithString:strPath)'s ¬
        stringByStandardizingPath
    set {bln, int} to (ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:oPath isDirectory:(reference))
    bln and (int ≠ 1)
end doesFileExist

-- doesPathExist :: FilePath -> IO Bool
on doesPathExist(strPath)
    set ca to current application
    ca's NSFileManager's defaultManager's ¬
        fileExistsAtPath:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath)
end doesPathExist

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

-- drawForest :: [Tree String] -> String
on drawForest(trees)
    intercalate("\n\n", map(my drawTree, trees))
end drawForest

-- drawTree :: Tree String -> String
on drawTree(tree)
    unlines(draw(tree))
end drawTree

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

-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if script is not c then
        if string is not c then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop

-- dropAround :: (a -> Bool) -> [a] -> [a]
-- dropAround :: (Char -> Bool) -> String -> String
on dropAround(p, xs)
    dropWhile(p, dropWhileEnd(p, xs))
end dropAround

-- dropFileName :: FilePath -> FilePath
on dropFileName(strPath)
    if strPath ≠ "" then
        if character -1 of strPath = "/" then
            strPath
        else
            set xs to init(splitOn("/", strPath))
            if xs ≠ {} then
                intercalate("/", xs) & "/"
            else
                "./"
            end if
        end if
    else
        "./"
    end if
end dropFileName

-- dropLength :: [a] -> [b] -> [b]
on dropLength(xs, ys)
    script go
        on |λ|(x, y)
            if 0 < length of x then
                if 0 < length of y then
                    |λ|(tail(x), tail(y))
                else
                    {}
                end if
            else
                y
            end if
        end |λ|
    end script
    go's |λ|(xs, ys)
end dropLength

-- dropLengthMaybe :: [a] -> [b] -> Maybe [b]
on dropLengthMaybe(xs, ys)
    script go
        on |λ|(x, y)
            if 0 < length of x then
                if 0 < length of y then
                    |λ|(tail(x), tail(y))
                else
                    Nothing()
                end if
            else
                Just(y)
            end if
        end |λ|
    end script
    go's |λ|(xs, ys)
end dropLengthMaybe

-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- dropWhile :: (Char -> Bool) -> String -> String
on dropWhile(p, xs)
    set lng to length of xs
    set i to 1
    tell mReturn(p)
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    drop(i - 1, xs)
end dropWhile

-- dropWhileEnd :: (a -> Bool) -> [a] -> [a]
-- dropWhileEnd :: (Char -> Bool) -> String -> String
on dropWhileEnd(p, xs)
    set i to length of xs
    tell mReturn(p)
        repeat while i > 0 and |λ|(item i of xs)
            set i to i - 1
        end repeat
    end tell
    take(i, xs)
end dropWhileEnd

-- dropWhileGen :: (a -> Bool) -> Gen [a] -> [a]
on dropWhileGen(p, xs)
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set v to xs's |λ|()
        end repeat
    end tell
    return cons(v, xs)
end dropWhileGen

-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if missing value is |Left| of e then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either

-- elem :: Eq a => a -> [a] -> Bool
on elem(x, xs)
    considering case
        xs contains x
    end considering
end elem

-- elemAtMay :: Int -> Dict -> Maybe (String, a)
-- elemAtMay :: Int -> [a] -> Maybe a
on elemAtMay(i, x)
    -- If x is a Dictionary then reads the Int as an index
    -- into the lexically sorted keys of the Dict, 
    -- returning a Maybe (Key, Value) pair.
    -- If x is a list, then return a Maybe a 
    -- (In either case, returns Nothing for an Int out of range)
    set bln to class of x is record
    if bln then
        set ks to keys(x)
        if i ≤ |length|(ks) then
            set k to item i of sort(ks)
            script pair
                on |λ|(v)
                    Just(Tuple(k, v))
                end |λ|
            end script
            bindMay(lookup(k, x), pair)
        end if
    else
        if i ≤ |length|(x) then
            Just(item i of x)
        else
            Nothing()
        end if
    end if
end elemAtMay

-- elemIndex :: Eq a => a -> [a] -> Maybe Inton elemIndex(x, xs)    -- Just the zero-based index of x in xs,    -- or Nothing if x is not found in xs.	set lng to length of xs	repeat with i from 1 to lng		if x = (item i of xs) then return Just(i - 1)	end repeat	return Nothing()end elemIndex

-- elemIndices :: Eq a => a -> [a] -> [Int]
on elemIndices(x, xs)
    script
        on |λ|(y, i)
            if y = x then
                {i}
            else
                {}
            end if
        end |λ|
    end script
    concatMap(result, xs)
end elemIndices

-- elems :: Map k a -> [a]
-- elems :: Set a -> [a]
on elems(x)
    if record is class of x then -- Dict
        tell current application to allValues() ¬
            of dictionaryWithDictionary_(x) ¬
            of its NSDictionary as list
    else -- Set
        (allObjects() of x) as list
    end if
end elems

-- encodedPath :: FilePath -> Percent Encoded String
on encodedPath(fp)
    tell current application
        set charSet to URLPathAllowedCharacterSet of its NSCharacterSet
        (stringByAddingPercentEncodingWithAllowedCharacters_(charSet) of ¬
            stringWithString_(fp) of its NSString) as string
    end tell
end encodedPath

-- enumFrom :: Enum a => a -> [a]
on enumFrom(x)
    script
        property v : missing value
        property blnNum : class of x is not text
        on |λ|()
            if missing value is not v then
                if blnNum then
                    set v to 1 + v
                else
                    set v to succ(v)
                end if
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom

-- enumFromPairs :: String -> [(String, Int)] -> Dict
on enumFromPairs(strName, kvs)
    set iMax to item 1 of item -1 of kvs
    set iMin to item 1 of item 1 of kvs
    script go
        on |λ|(a, kv)
            set {k, v} to kv
            insertMap(insertMap(a, k, ¬
                {type:"enum", |name|:¬
                    strName, |key|:k, min:iMin, max:iMax, value:v}), v, k)
        end |λ|
    end script
    foldl(go, {|name|:strName, min:iMin, max:iMax}, kvs)
end enumFromPairs

-- enumFromThen :: Int -> Int -> Gen [Int]
on enumFromThen(m, n)
    -- A non-finite stream of integers,
    -- starting with m and n, and continuing
    -- with the same interval.
    script
        property d : n - m
        property v : m
        on |λ|()
            set x to v
            set v to d + v
            return x
        end |λ|
    end script
end enumFromThen

-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    set gap to x2 - x1
    set d to max(1, abs(gap)) * (signum(gap))
    repeat with i from x1 to y by d
        set end of xs to i
    end repeat
    return xs
end enumFromThenTo

-- enumFromThenToChar :: Char -> Char -> Char -> [Char]
on enumFromThenToChar(x1, x2, y)
    set {int1, int2, intY} to {id of x1, id of x2, id of y}
    set xs to {}
    repeat with i from int1 to intY by (int2 - int1)
        set end of xs to character id i
    end repeat
    return xs
end enumFromThenToChar

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo

-- enumFromToChar :: Char -> Char -> [Char]
on enumFromToChar(m, n)
    set {intM, intN} to {id of m, id of n}
    if intM ≤ intN then
        set xs to {}
        repeat with i from intM to intN
            set end of xs to character id i
        end repeat
        return xs
    else
        {}
    end if
end enumFromToChar

-- enumFromTo_ :: Enum a => a -> a -> [a]
on enumFromTo_(m, n)
    if m ≤ n then
        set x to fromEnum(m)
        set y to fromEnum(n)
        set xs to {}
        repeat with i from x to y
            set end of xs to i
        end repeat
        map(toEnum(m), xs)
    else
        return {}
    end if
end enumFromTo

-- eq (==) :: Eq a => a -> a -> Bool
on eq(a, b)
    a = b
end eq

-- eqDate :: Date -> Date -> Bool
on eqDate(dte, dte1)
    -- True if the date parts of two date-time objects
    -- (ignoring the time parts) are the same.
    tell dte
        its year = year of dte1 ¬
            and its month = month of dte1 ¬
            and its day = day of dte1
    end tell
end eqDate

-- evalJSLR :: String -> Either String a
on evalJSLR(strJS)
    -- gJSC can be declared in the global namespace,
    -- but unless the reference is released before the 
    -- end of the script (e.g. `set gJSC to null`)
    -- it will persist, and
    -- Script Editor will be unable to save a .scpt file
    set gJSC to current application's JSContext's new()
    set v to unwrap((gJSC's evaluateScript:(strJS))'s toObject())
    if v is missing value then
        |Left|("JS evaluation error")
    else
        |Right|(v)
    end if
end evalJSLR

-- evalJSMay :: String -> Maybe a
on evalJSMay(strJS)
    -- use framework "Foundation"
    -- use framework "JavaScriptCore"
    -- gJSC can be declared in the global namespace,
    -- but unless the reference is released before the 
    -- end of the script (e.g. `set gJSC to null`)
    -- it will persist, and
    -- Script Editor will be unable to save a .scpt file
    try -- NB if gJSC is global it must be released 
        -- (e.g. set to null) at end of script
        gJSC's evaluateScript
    on error
        set gJSC to current application's JSContext's new()
        log ("new JSC")
    end try
    set v to unwrap((gJSC's evaluateScript:(strJS))'s toObject())
    if v is missing value then
        Nothing()
    else
        Just(v)
    end if
end evalJSMay

-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even

-- exp :: Float -> Float
on exp(n)
    Just of evalJSMay(("Math.exp(" & n as string) & ")")
end exp

-- fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
on fTable(s, xShow, fxShow, f, xs)
    set ys to map(xShow, xs)
    set w to maximum(map(my |length|, ys))
    script arrowed
        on |λ|(a, b)
            justifyRight(w, space, a) & " -> " & b
        end |λ|
    end script
    s & linefeed & unlines(zipWith(arrowed, ¬
        ys, map(compose(fxShow, f), xs)))
end fTable

-- fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
on fanArrow(f, g)
    -- Compose a function from a simple value to a tuple of
    -- the separate outputs of two different functions
    script
        on |λ|(x)
            Tuple(mReturn(f)'s |λ|(x), mReturn(g)'s |λ|(x))
        end |λ|
    end script
end fanArrow

-- filePath :: String -> FilePath
on filePath(s)
    ((current application's ¬
        NSString's stringWithString:s)'s ¬
        stringByStandardizingPath()) as string
end filePath

-- filePathTree :: filePath -> [Tree String] -> Tree FilePath
on filePathTree(fpAnchor, trees)
    script go
        on |λ|(fp)
            script
                on |λ|(tree)
                    set strPath to fp & "/" & (root of tree)
                    
                    Node(strPath, map(go's |λ|(strPath), nest of tree))
                end |λ|
            end script
        end |λ|
    end script
    
    Node(fpAnchor, map(go's |λ|(fpAnchor), trees))
end filePathTree

-- fileSize :: FilePath -> Either String Int
on fileSize(fp)
    script fs
        on |λ|(rec)
            |Right|(NSFileSize of rec)
        end |λ|
    end script
    bindLR(my fileStatus(fp), fs)
end fileSize

-- fileStatus :: FilePath -> Either String Dict
on fileStatus(fp)
    set e to reference
    set {v, e} to current application's NSFileManager's defaultManager's ¬
        attributesOfItemAtPath:fp |error|:e
    if v is not missing value then
        |Right|(v as record)
    else
        |Left|((localizedDescription of e) as string)
    end if
end fileStatus

-- fileUTI :: FilePath -> Either String String
on fileUTI(fp)
    set {uti, e} to (current application's ¬
        NSWorkspace's sharedWorkspace()'s ¬
        typeOfFile:fp |error|:(reference)) as list
    if uti is missing value then
        |Left|(e's localizedDescription() as text)
    else
        |Right|(uti as text)
    end if
end fileUTI

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        if {text, string} contains class of xs then
            lst as text
        else
            lst
        end if
    end tell
end filter

-- filterGen :: (a -> Bool) -> Gen [a] -> Gen [a]
on filterGen(p, gen)
    -- Non-finite stream of values which are 
    -- drawn from gen, and satisfy p
    script
        property mp : mReturn(p)'s |λ|
        on |λ|()
            set v to gen's |λ|()
            repeat until mp(v)
                set v to gen's |λ|()
            end repeat
            return v
        end |λ|
    end script
end filterGen

-- filterTree (a -> Bool) -> Tree a -> [a]
on filterTree(p, tree)
    -- List of all values in the tree
    -- which match the predicate p.
    
    script go
        property q : mReturn(p)'s |λ|
        on |λ|(x, xs)
            if q(x) then
                {x} & concat(xs)
            else
                concat(xs)
            end if
        end |λ|
    end script
    
    foldTree(go, tree)
end filterTree

-- filteredTree (a -> Bool) -> Tree a -> Tree a
on filteredTree(p, tree)
    -- A tree including only those children
    -- which either match the predicate p, or have
    -- descendants which match the predicate p.
    
    script go
        property q : mReturn(p)
        on |λ|(x, xs)
            script test
                on |λ|(subTree)
                    {} ≠ (nest of subTree) or (|λ|(root of subTree) of q)
                end |λ|
            end script
            Node(x, filter(test, xs))
        end |λ|
    end script
    
    foldTree(go, tree)
end filteredTree

-- find :: (a -> Bool) -> [a] -> Maybe a
on find(p, xs)
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return Just(item i of xs)
        end repeat
        Nothing()
    end tell
end find

-- findGen :: (a -> Bool) -> Gen [a] -> Maybe a
on findGen(p, gen)
    -- Just the first match for the predicate p
    -- in the generator stream gen, or Nothing
    -- if no match is found.
    set mp to mReturn(p)
    set v to gen's |λ|()
    repeat until missing value is v or (|λ|(v) of mp)
        set v to (|λ|() of gen)
    end repeat
    if missing value is v then
        Nothing()
    else
        Just(v)
    end if
end findGen

-- findIndex :: (a -> Bool) -> [a] -> Maybe Int
on findIndex(p, xs)
    -- Just the zero-based index of the first
    -- (left-to-right match) for for the predicate p in xs, 
    -- or Nothing if no match is found.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return Just(i - 1)
        end repeat
        return Nothing()
    end tell
end findIndex

-- findIndexR :: (a -> Bool) -> [a] -> Maybe Int
on findIndexR(p, xs)
    -- Just the zero-based index of the first
    -- (right-to-left match) for for the predicate p in xs, 
    -- or Nothing if no match is found.
    tell mReturn(p)
        set lng to length of xs
        repeat with i from lng to 1 by -1
            if |λ|(item i of xs) then return Just(i - 1)
        end repeat
        return Nothing()
    end tell
end findIndexR

-- findIndices :: (a -> Bool) -> [a] -> [Int]
on findIndices(p, xs)
    -- List of zero-based indices of 
    -- any matches for p in xs.
    script
        property f : mReturn(p)
        on |λ|(x, i, xs)
            if f's |λ|(x, i, xs) then
                {i - 1}
            else
                {}
            end if
        end |λ|
    end script
    concatMap(result, xs)
end findIndices

-- findTree :: (a -> Bool) -> Tree a -> Maybe Tree a
on findTree(p, tree)
    -- The first of any nodes in the tree which match the predicate p
    -- (For all matches, see treeMatches)
    script go
        property pf : mReturn(p)'s |λ|
        on |λ|(oNode)
            if pf(root of oNode) then
                Just(oNode)
            else
                set xs to nest of oNode
                set lng to length of xs
                
                script inNest
                    on |λ|(tpl)
                        lng < fst(tpl) or (not (Nothing of snd(tpl)))
                    end |λ|
                end script
                
                script nextPeer
                    on |λ|(tpl)
                        Tuple(1 + fst(tpl), go's |λ|(item (fst(tpl)) of xs))
                    end |λ|
                end script
                
                if 0 < lng then
                    snd(|until|(inNest, nextPeer, Tuple(1, Nothing())))
                else
                    Nothing()
                end if
            end if
        end |λ|
    end script
    
    go's |λ|(tree)
end findTree

-- first :: (a -> b) -> ((a, c) -> (b, c))
on |first|(f)
   -- A simple function lifted to one which applies to a tuple, 
   -- transforming only the first item of that tuple
    script
        on |λ|(xy)
            Tuple(mReturn(f)'s |λ|(|1| of xy), |2| of xy)
        end |λ|
    end script
end |first|

-- flatten :: NestedList a -> [a]
on flatten(t)
    -- A flat list derived from a nested list.
    if list is class of t then
        concatMap(my flatten, t)
    else
        t
    end if
end flatten

-- flattenTree :: Tree a -> [a]
on flattenTree(node)
    -- The root elements of a tree in pre-order.
    script go
        on |λ|(x, xs)
            {root of x} & foldr(go, xs, nest of x)
        end |λ|
    end script
    go's |λ|(node, {})
end flattenTree

-- flip :: (a -> b -> c) -> b -> a -> c
on flip(f)
    script
        property g : mReturn(f)
        on |λ|(x, y)
            g's |λ|(y, x)
        end |λ|
    end script
end flip

-- floor :: Num -> Int
on floor(x)
    if class of x is record then
        set nr to properFracRatio(x)
    else
        set nr to properFraction(x)
    end if
    set n to fst(nr)
    if 0 > snd(nr) then
        n - 1
    else
        n
    end if
end floor

-- fmap (<$>) :: Functor f => (a -> b) -> f a -> f b
on fmap(f, fa)
    set c to class of fa
    if c is record and keys(fa) contains "type" then
        set t to |type| of fa
        if "Either" = t then
            set fm to my fmapLR
        else if "Maybe" = t then
            set fm to my fmapMay
        else if "Node" = t then
            set fm to my fmapTree
        else if "Tuple" = t then
            set fm to my fmapTuple
        else
            set fm to my map
        end if
        |λ|(f, fa) of mReturn(fm)
    else if c is text then
        map(f, characters of fa)
    else if c is list then
        map(f, fa)
    else
        missing value
    end if
end fmap

-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen

-- fmapLR (<$>) :: (a -> b) -> Either a a -> Either a b
on fmapLR(f, lr)
    if |Left| of lr is missing value then
        |Right|(|λ|(|Right| of lr) of mReturn(f))
    else
        lr
    end if
end fmapLR

-- fmapMay (<$>) :: (a -> b) -> Maybe a -> Maybe b
on fmapMay(f, mb)
    if Nothing of mb then
        mb
    else
        Just(|λ|(Just of mb) of mReturn(f))
    end if
end fmapMay

-- fmapTree :: (a -> b) -> Tree a -> Tree b
on fmapTree(f, tree)
    script go
        property g : |λ| of mReturn(f)
        on |λ|(x)
            set xs to nest of x
            if xs ≠ {} then
                set ys to map(go, xs)
            else
                set ys to xs
            end if
            Node(g(root of x), ys)
        end |λ|
    end script
  |λ|(tree) of go
end fmapTree

-- fmapTuple (<$>) :: (a -> b) -> (a, a) -> (a, b)
on fmapTuple(f, tpl)
    Tuple(|1| of tpl, |λ|(|2| of tpl) of mReturn(f))
end fmapTuple

-- foldMapTree :: Monoid m => (a -> m) -> Tree a -> m
on foldMapTree(f, tree)
    script go
        property g : mReturn(f)'s |λ|
        on |λ|(x)
            if length of (nest of x) > 0 then
                mappend(g(root of x), ¬
                    foldl1(my mappend, (map(go, nest of x))))
            else
                g(root of x)
            end if
        end |λ|
    end script
    |λ|(tree) of go
end foldMapTree

-- foldTree :: (a -> [b] -> b) -> Tree a -> b
on foldTree(f, tree)
    script go
        property g : mReturn(f)
        on |λ|(oNode)
            tell g to |λ|(root of oNode, map(go, nest of oNode))
        end |λ|
    end script
    |λ|(tree) of go
end foldTree

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
      set v to startValue
      set lng to length of xs
      repeat with i from 1 to lng
          set v to |λ|(v, item i of xs, i, xs)
      end repeat
      return v
      end tell
end foldl

-- foldl1 :: (a -> a -> a) -> [a] -> a
on foldl1(f, xs)
    if length of xs > 1 then
        tell mReturn(f)
            set v to {item 1 of xs}
            set lng to length of xs
            repeat with i from 2 to lng
                set v to |λ|(v, item i of xs, i, xs)
            end repeat
            return v
        end tell
    else
        item 1 of xs
    end if
end foldl1

-- foldl1May :: (a -> a -> a) -> [a] -> Maybe a
on foldl1May(f, xs)
    set lng to length of xs
    if lng > 0 then
        if lng > 1 then
            tell mReturn(f)
                set v to {item 1 of xs}
                set lng to length of xs
                repeat with i from 2 to lng
                    set v to |λ|(v, item i of xs, i, xs)
                end repeat
                return Just(v)
            end tell
        else
            Just(item 1 of xs)
        end if
    else
        Nothing()
    end if
end foldl1May

-- foldlTree :: (b -> a -> b) -> b -> Tree a -> b
on foldlTree(f, acc, tree)
    script go
        property mf : mReturn(f)
        on |λ|(a, x)
            foldl(go, |λ|(a, root of x) of mf, nest of x)
        end |λ|
    end script
    |λ|(acc, tree) of go
end foldlTree

-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr

-- foldr1 :: (a -> a -> a) -> [a] -> a
on foldr1(f, xs)
    if length of xs > 1 then
        tell mReturn(f)
            set v to item -1 of xs
            set lng to length of xs
            repeat with i from lng - 1 to 1 by -1
                set v to |λ|(item i of xs, v, i, xs)
            end repeat
            return v
        end tell
    else
        xs
    end if
end foldr1

-- foldr1May :: (a -> a -> a) -> [a] -> Maybe a
on foldr1May(f, xs)
    set lng to length of xs
    if lng > 0 then
        tell mReturn(f)
            set v to item -1 of xs
            repeat with i from lng - 1 to 1 by -1
                set v to |λ|(item i of xs, v, i, xs)
            end repeat
            return Just(v)
        end tell
    else
        Nothing()
    end if
end foldr1May

-- foldrTree :: (a -> b -> b) -> b -> Tree a -> b
on foldrTree(f, acc, tree)
    script go
        property mf : mReturn(f)
        on |λ|(x, a)
            foldr(go, |λ|(root of x, a) of mf, nest of x)
        end |λ|
    end script
    |λ|(tree, acc) of go
end foldrTree

-- forestFromJSON :: String -> [Tree a]
on forestFromJSON(strJSON)
    set lr to jsonParseLR(strJSON)
    if missing value is |Left| of lr then
        map(my treeFromNestedList, |Right| of lr)
    else
        {}
    end if
end forestFromJSON


-- fromEnum :: Enum a => a -> Int
on fromEnum(x)
    set c to class of x
    if c is boolean then
        if x then
            1
        else
            0
        end if
    else if c is text then
        if x ≠ "" then
            id of x
        else
            missing value
        end if
    else
        x as integer
    end if
end fromEnum

-- fromLeft :: a -> Either a b -> a
on fromLeft(def, lr)
    if isLeft(lr) then
        |Left| of lr
    else
        def
    end if
end fromLeft

-- fromMaybe :: a -> Maybe a -> a
on fromMaybe(default, mb)
    if Nothing of mb then
        default
    else
        Just of mb
    end if
end fromMaybe

-- fromRight :: b -> Either a b -> b
on fromRight(def, lr)
    if isRight(lr) then
        |Right| of lr
    else
        def
    end if
end fromRight

-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst

-- ft :: (Int, Int) -> [Int]
on ft(m, n)
    -- Abbreviation for quick testing
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end ft

-- gcd :: Int -> Int -> Int
on gcd(a, b)
    set x to abs(a)
    set y to abs(b)
    repeat until y = 0
        if x > y then
            set x to x - y
        else
            set y to y - x
        end if
    end repeat
    return x
end gcd

-- genericIndexMay :: [a] -> Int -> Maybe a
on genericIndexMay(xs, i)
    if i < (length of xs) and i ≥ 0 then
        Just(item (i + 1) of xs)
    else
        Nothing()
    end if
end genericIndexMay

-- getCurrentDirectory :: IO FilePath
on getCurrentDirectory()
    set ca to current application
    ca's NSFileManager's defaultManager()'s currentDirectoryPath as string
end getCurrentDirectory

-- getDirectoryContents :: FilePath -> IO [FilePath]
on getDirectoryContents(strPath)
    set ca to current application
    (ca's NSFileManager's defaultManager()'s ¬
        contentsOfDirectoryAtPath:(stringByStandardizingPath of (¬
            ca's NSString's stringWithString:(strPath))) ¬
            |error|:(missing value)) as list
end getDirectoryContents

-- getDirectoryContentsLR :: FilePath -> Either String IO [FilePath]
on getDirectoryContentsLR(strPath)
    set ca to current application
    set {xs, e} to (ca's NSFileManager's defaultManager()'s ¬
        contentsOfDirectoryAtPath:(stringByStandardizingPath of ¬
            (ca's NSString's stringWithString:(strPath))) ¬
            |error|:(reference))
    if xs is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(xs as list)
    end if
end getDirectoryContentsLR

-- getFinderDirectory :: IO FilePath
on getFinderDirectory()
    tell application "Finder" to POSIX path of (insertion location as alias)
end getFinderDirectory

-- getHomeDirectory :: IO FilePath
on getHomeDirectory()
    current application's NSHomeDirectory() as string
end getHomeDirectory

-- getTemporaryDirectory :: IO FilePath
on getTemporaryDirectory()
    current application's NSTemporaryDirectory() as string
end getTemporaryDirectory

-- group :: Eq a => [a] -> [[a]]
on group(xs)
    script eq
        on |λ|(a, b)
            a = b
        end |λ|
    end script
    
    groupBy(eq, xs)
end group

-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
on groupBy(f, xs)
    -- Typical usage: groupBy(on(eq, f), xs)
    set mf to mReturn(f)
    
    script enGroup
        on |λ|(a, x)
            if length of (active of a) > 0 then
                set h to item 1 of active of a
            else
                set h to missing value
            end if
            
            if h is not missing value and mf's |λ|(h, x) then
                {active:(active of a) & {x}, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end |λ|
    end script
    
    if length of xs > 0 then
        set dct to foldl(enGroup, {active:{item 1 of xs}, sofar:{}}, rest of xs)
        if length of (active of dct) > 0 then
            sofar of dct & {active of dct}
        else
            sofar of dct
        end if
    else
        {}
    end if
end groupBy

-- groupSortOn :: Ord b => (a -> b) -> [a] -> [[a]]
-- groupSortOn :: Ord b => [((a -> b), Bool)]  -> [a] -> [[a]]
on groupSortOn(f, xs)
    -- Sort and group a list by comparing the results of a key function
    -- applied to each element. groupSortOn f is equivalent to
    -- groupBy eq $ sortBy (comparing f),
    -- but has the performance advantage of only evaluating f once for each
    -- element in the input list.
    -- This is a decorate-(group.sort)-undecorate pattern, as in the
    -- so-called 'Schwartzian transform'.
    -- Groups are arranged from from lowest to highest.
    script keyBool
        on |λ|(a, x)
            if class of x is boolean then
                {asc:x, fbs:fbs of a}
            else
                {asc:true, fbs:({Tuple(x, asc of a)} & fbs of a)}
            end if
        end |λ|
    end script
    set {fs, bs} to {|1|, |2|} of unzip(fbs of foldl(keyBool, ¬
        {asc:true, fbs:{}}, flatten({f})))
    
    set intKeys to length of fs
    set ca to current application
    script dec
        property gs : map(my mReturn, fs)
        on |λ|(x)
            set nsDct to (ca's NSMutableDictionary's ¬
                dictionaryWithDictionary:{val:x})
            repeat with i from 1 to intKeys
                (nsDct's setValue:((item i of gs)'s |λ|(x)) ¬
                    forKey:(character id (96 + i)))
            end repeat
            nsDct as record
        end |λ|
    end script
    
    script descrip
        on |λ|(bool, i)
            ca's NSSortDescriptor's ¬
                sortDescriptorWithKey:(character id (96 + i)) ¬
                    ascending:bool
        end |λ|
    end script
    
    script grpUndec
        on |λ|(grp)
            script
                on |λ|(x)
                    val of x
                end |λ|
            end script
            map(result, grp)
        end |λ|
    end script
    
    script aEq
        on |λ|(p, q)
            (a of p) = (a of q)
        end |λ|
    end script
    
    -- Sorted, grouped, undecorated
    map(grpUndec, ¬
        groupBy(aEq, ((ca's NSArray's arrayWithArray:map(dec, xs))'s ¬
            sortedArrayUsingDescriptors:map(descrip, bs)) as list))
end groupSortOn

-- gt :: Ord a => a -> a -> Bool
on gt(x, y)
    set c to class of x
    if record is c or list is c then
        fst(x) > fst(y)
    else
        x > y
    end if
end gt

-- head :: [a] -> a
on head(xs)
    if xs = {} then
        missing value
    else
        item 1 of xs
    end if
end head

-- headMay :: [a] -> Maybe a
on headMay(xs)
    if xs = {} then
        Nothing()
    else
        Just(item 1 of xs)
    end if
end headMay

-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity

-- if_ :: Bool -> a -> a -> a
on if_(bool, x, y)
    if bool then
        x
    else
        y
    end if
end if_

-- indented :: String -> String -> String
on indented(strIndent, s)
    script
        on |λ|(x)
            if x ≠ "" then
                strIndent & x
            else
                x
            end if
        end |λ|
    end script
    unlines(map(result, |lines|(s)))
end indented

-- index (!!) :: [a] -> Int -> Maybe a
-- index (!!) :: Gen [a] -> Int -> Maybe a
-- index (!!) :: String -> Int -> Maybe Char
on |index|(xs, i)
    if script is class of xs then
        repeat with j from 1 to i
            set v to |λ|() of xs
        end repeat
        if missing value is not v then
            Just(v)
        else
            Nothing()
        end if
    else
        if length of xs < i then
            Nothing()
        else
            Just(item i of xs)
        end if
    end if
end |index|

-- indexOf :: Eq a => [a] -> [a] -> Maybe Int
-- indexOf :: String -> String -> Maybe Int
on indexOf(pat, src)
    if class of src is text then
        set tpl to breakOn(pat, src)
        if 0 < length of (|2| of tpl) then
            Just((length of |1| of tpl) + 1)
        else
            Nothing()
        end if
    else
        script pfx
            on |λ|(xs)
                isPrefixOf(pat, xs)
            end |λ|
        end script
        findIndex(pfx, tails(src))
    end if
end indexOf

-- init :: [a] -> [a]
-- init :: [String] -> [String]
on init(xs)
    set blnString to class of xs = string
    set lng to length of xs
    
    if lng > 1 then
        if blnString then
            text 1 thru -2 of xs
        else
            items 1 thru -2 of xs
        end if
    else if lng > 0 then
        if blnString then
            ""
        else
            {}
        end if
    else
        missing value
    end if
end init


-- initMay :: [a] -> Maybe [a]
-- initMay :: [String] -> Maybe [String]
on initMay(xs)
    set blnString to class of xs = string
    set lng to length of xs
    if lng > 1 then
        if blnString then
            Just(text 1 thru -2 of xs)
        else
            Just(items 1 thru -2 of xs)
        end if
    else if lng > 0 then
        if blnString then
            Just("")
        else
            Just({})
        end if
    else
        Nothing()
    end if
end initMay

-- inits :: [a] -> [[a]]
-- inits :: String -> [String]
on inits(xs)
    script elemInit
        on |λ|(_, i, xs)
            items 1 thru i of xs
        end |λ|
    end script
    
    script charInit
        on |λ|(_, i, xs)
            text 1 thru i of xs
        end |λ|
    end script
    
    if class of xs is string then
        {""} & map(charInit, xs)
    else
        {{}} & map(elemInit, xs)
    end if
end inits

-- insert :: Ord a => a -> [a] -> [a]
on insert(x, ys)
    insertBy(my compare, x, ys)
end insert

-- insertBy :: (a -> a -> Ordering) -> a -> [a] -> [a]
on insertBy(cmp, x, ys)
    set lng to length of ys
    if lng > 0 then
        tell mReturn(cmp)
            set bln to false
            repeat with i from 1 to lng
                if |λ|(item i of ys, x) > 0 then
                    set bln to true
                    exit repeat
                end if
            end repeat
        end tell
        if bln then
            if i > 1 then
                items 1 thru (i - 1) of ys & x & items i thru -1 of ys
            else
                {x} & ys
            end if
        else
            ys & x
        end if
    else
        {x}
    end if
end insertBy

-- insertDict :: String -> a -> Dict -> Dicton insertDict(k, v, rec)    tell current application        tell dictionaryWithDictionary_(rec) of its NSMutableDictionary            its setValue:v forKey:(k as string)            it as record        end tell    end tellend insertDict

-- insertSet :: Ord a => a -> Set a -> Set a
on insertSet(x, oSet)
    oSet's addObject:(x)
    return oSet
end insertSet

-- intToDigit :: Int -> Char
on intToDigit(n)
    if n ≥ 0 and n < 16 then
        character (n + 1) of "0123456789ABCDEF"
    else
        "?"
    end if
end intToDigit

-- intercalate :: [a] -> [[a]] -> [a]
-- intercalate :: String -> [String] -> String
on intercalate(sep, xs)
    if class of xs is text then
        set {dlm, my text item delimiters} to ¬
            {my text item delimiters, delim}
        set s to xs as text
        set my text item delimiters to dlm
    else
        concat(intersperse(sep, xs))
    end if
end intercalate

-- intercalateS :: String -> [String] -> String
on intercalateS(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalateS

-- intersect :: (Eq a) => [a] -> [a] -> [a]
on intersect(xs, ys)
    if length of xs < length of ys then
        set {shorter, longer} to {xs, ys}
    else
        set {longer, shorter} to {xs, ys}
    end if
    if shorter ≠ {} then
        set lst to {}
        repeat with x in shorter
            if longer contains x then set end of lst to contents of x
        end repeat
        lst
    else
        {}
    end if
end intersect

-- intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
on intersectBy(eq, xs, ys)
    if length of xs > 0 and length of ys > 0 then
        set p to curry(eq)
        script matchFound
            on |λ|(x)
                any(p's |λ|(x), ys)
            end |λ|
        end script
        
        filter(matchFound, xs)
    else
        {}
    end if
end intersectBy

-- intersectListsBy :: (a -> a -> Bool) -> [[a]] -> [a]
on intersectListsBy(fnEq, xs)
    script
        property eq : mReturn(fnEq)
        on |λ|(a, x)
            intersectBy(eq, a, x)
        end |λ|
    end script
    foldr1(result, xs)
end intersectionBy

-- intersection :: Ord a => Set a -> Set a -> Set a
on intersection(a, b)
    set s to current application's NSMutableSet's alloc's init()
    s's setSet:(a)
    s's intersectSet:(b)
    return s
end intersection

-- intersperse :: a -> [a] -> [a]
-- intersperse :: Char -> String -> String
on intersperse(sep, xs)
    -- intersperse(0, [1,2,3]) -> [1, 0, 2, 0, 3]
    set lng to length of xs
    if lng > 1 then
        set acc to {item 1 of xs}
        repeat with i from 2 to lng
            set acc to acc & {sep, item i of xs}
        end repeat
        if class of xs is string then
            concat(acc)
        else
            acc
        end if
    else
        xs
    end if
end intersperse

-- isAlpha :: Char -> Bool
on isAlpha(c)
    set ca to current application
    set oRgx to ca's NSRegularExpression's ¬
        regularExpressionWithPattern:("[A-Za-z\\u00C0-\\u00FF]") ¬
            options:(ca's NSRegularExpressionAnchorsMatchLines as integer) ¬
            |error|:(missing value)
    set oString to ca's NSString's stringWithString:c
    0 < (oRgx's numberOfMatchesInString:oString options:0 ¬
        range:{location:0, |length|:1})
end isAlpha

-- isChar :: a -> Bool
on isChar(x)
    class of x is string and length of x is 1
end isChar

-- isDigit :: Char -> Bool
on isDigit(c)
    set n to (id of c)
    48 ≤ n and 57 ≥ n
end isDigit

-- isInfixOf :: (Eq a) => [a] -> [a] -> Bool
-- isInfixOf :: String -> String -> Bool
on isInfixOf(needle, haystack)
    haystack contains needle
end isInfixOf

-- isLeft :: Either a b -> Bool
on isLeft(x)
    set dct to current application's ¬
        NSDictionary's dictionaryWithDictionary:x
    (dct's objectForKey:"type") as text = "Either" and ¬
        (dct's objectForKey:"Right") as list = {missing value}
end isLeft

-- isLower :: Char -> Bool
on isLower(c)
    set d to (id of c) - 97 -- id of "a"
    d ≥ 0 and d < 26
end isLower

-- isMaybe :: a -> Bool
on isMaybe(x)
    -- use framework "Foundation"
    -- use scripting additions
    if class of x is record then
        set ca to current application
        set v to ((ca's NSDictionary's ¬
            dictionaryWithDictionary:x)'s ¬
            objectForKey:"type")
        v is not missing value ¬
            and (v's isKindOfClass:(ca's NSString)) ¬
            and (v as string = "Maybe")
    else
      false
    end if
end isMaybe

-- isNull :: [a] -> Bool
-- isNull :: String -> Bool
on isNull(xs)
    if class of xs is string then
        "" = xs
    else
        {} = xs
    end if
end isNull

-- isPrefixOf :: [a] -> [a] -> Bool
-- isPrefixOf :: String -> String -> Bool
on isPrefixOf(xs, ys)
    -- isPrefixOf takes two lists or strings and returns 
    --  true if and only if the first is a prefix of the second.
    script go
        on |λ|(xs, ys)
            set intX to length of xs
            if intX < 1 then
                true
            else if intX > length of ys then
                false
            else if class of xs is string then
                (offset of xs in ys) = 1
            else
                set {xxt, yyt} to {Just of uncons(xs), Just of uncons(ys)}
                ((|1| of xxt) = (|1| of yyt)) and |λ|(|2| of xxt, |2| of yyt)
            end if
        end |λ|
    end script
    go's |λ|(xs, ys)
end isPrefixOf

-- isRight :: Either a b -> Bool
on isRight(x)
    set dct to current application's ¬
        NSDictionary's dictionaryWithDictionary:x
    (dct's objectForKey:"type") as text = "Either" and ¬
        (dct's objectForKey:"Left") as list = {missing value}
end isRight

-- isSortedBy :: (a -> a -> Bool) -> [a] -> Bool
on isSortedBy(cmp, xs)
    -- The 'isSortedBy' function returns true iff the predicate returns true
    -- for all adjacent pairs of elements in the list.
    script LE
        on |λ|(x)
            x < 1
        end |λ|
    end script
    (length of xs < 2) or all(LE, zipWith(cmp, xs, tail(xs)))
end isSortedBy

-- isSpace :: Char -> Bool
on isSpace(c)
    set i to id of c
    32 = i or (9 ≤ i and 13 ≥ i)
end isSpace

-- isSubsequenceOf :: Eq a => [a] -> [a] -> Bool
-- isSubsequenceOf :: String -> String -> Bool
on isSubsequenceOf(xs, ys)
    script iss
        on |λ|(a, b)
            if a ≠ {} then
                if b ≠ {} then
                    if item 1 of a = item 1 of b then
                        |λ|(rest of a, rest of b)
                    else
                        |λ|(a, rest of b)
                    end if
                else
                    false
                end if
            else
                true
            end if
        end |λ|
    end script
    
    if class of xs = string then
        tell iss to |λ|(characters of xs, characters of ys)
    else
        tell iss to |λ|(xs, ys)
    end if
end isSubsequenceOf

-- isSubsetOf :: Ord a => Set a -> Set a -> Bool
on isSubsetOf(objcSetA, objcSetB)
    objcSetA's isSubsetOfSet:(objcSetB)
end isSubsetOf

-- isSuffixOf :: Eq a => [a] -> [a] -> Bool
-- isSuffixOf :: String -> String -> Bool
on isSuffixOf(ns, hs)
    script go
        on |λ|(delta)
            ns = dropLength(delta, hs)
        end |λ|
    end script
    bindMay(dropLengthMaybe(ns, hs), go)
end isSuffixOf

-- isUpper :: Char -> Bool
on isUpper(c)
    set d to (id of c) - 65 -- id of "A"
    d ≥ 0 and d < 26
end isUpper

-- iso8601Local :: Date -> String
on iso8601Local(dte)
    (dte as «class isot» as string)
end iso8601Local

-- iterate :: (a -> a) -> a -> Gen [a]
on iterate(f, x)
    script
        property v : missing value
        property g : mReturn(f)
        on |λ|()
            if missing value is v then
                set v to x
            else
                set v to g's |λ|(v)
            end if
            return v
        end |λ|
    end script
end iterate

-- iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
on iterateUntil(p, f, x)
    script
        property mp : mReturn(p)'s |λ|
        property mf : mReturn(f)'s |λ|
        property lst : {x}
        on |λ|(v)
            repeat until mp(v)
                set v to mf(v)
                set end of lst to v
            end repeat
            return lst
        end |λ|
    end script
    |λ|(x) of result
end iterateUntil

-- join :: Monad m => m (m a) -> m a
on join(x)
    bind(x, my identity)
end join

-- jsonFromTree :: Tree a -> String
on jsonFromTree(tree)
    script go
        on |λ|(x)
            {root of x, map(go, nest of x)}
        end |λ|
    end script
    set ca to current application
    ca's (NSString's alloc()'s ¬
        initWithData:((ca's (NSJSONSerialization's ¬
            dataWithJSONObject:(|λ|(tree) of go) ¬
                options:0 |error|:(missing value)))) ¬
            encoding:(ca's NSUTF8StringEncoding)) as string
end jsonFromTree

-- jsonLog :: a -> IO ()
on jsonLog(e)
    log showJSON(e)
end jsonLog

-- jsonParseLR :: String -> Either String a
on jsonParseLR(s)
    set ca to current application
    set {x, e} to ca's NSJSONSerialization's ¬
        JSONObjectWithData:((ca's NSString's stringWithString:s)'s ¬
            dataUsingEncoding:(ca's NSUTF8StringEncoding)) ¬
            options:0 |error|:(reference)
    if x is missing value then
        |Left|(e's localizedDescription() as string)
    else
        if 1 = (x's isKindOfClass:(ca's NSArray)) as integer then
            |Right|(x as list)
        else
            |Right|(item 1 of (x as list))
        end if
    end if
end jsonParseLR

-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft

-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight

-- keys :: Dict -> [String]
on keys(rec)
    (current application's NSDictionary's dictionaryWithDictionary:rec)'s allKeys() as list
end keys

-- kleisliCompose (>=>) :: Monad m => (a -> m b) -> (b -> m c) -> (a -> m c)
on kleisliCompose(f, g)
    script
        on |λ|(x)
            bind(mReturn(f)'s |λ|(x), g)
        end |λ|
    end script
end kleisliCompose

-- last :: [a] -> a
on |last|(xs)
        item -1 of xs
end |last|

-- lastMay :: [a] -> Maybe a
on lastMay(xs)
    if length of xs > 0 then
        Just(item -1 of xs)
    else
        Nothing()
    end if
end lastMay

-- lcm :: Int -> Int -> Int
on lcm(x, y)
    if (x = 0 or y = 0) then
        0
    else
        abs(floor(x / (gcd(x, y))) * y)
    end if
end lcm

-- lefts :: [Either a b] -> [a]
on lefts(xs)
    script go
        on |λ|(x)
            if class of x is record then
                set ks to keys(x)
                if ks contains "type" and ks contains "Left" then
                    {x}
                else
                    {}
                end if
            else
                {}
            end if
        end |λ|
    end script
    concatMap(go, xs)
end lefts

-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|

-- levelNodes :: Tree a -> [[Tree a]]
on levelNodes(tree)
    script p
        on |λ|(xs)
            length of xs < 1
        end |λ|
    end script
    
    script f
        on |λ|(xs)
            script nest
                on |λ|(Node)
                    nest of Node
                end |λ|
            end script
            concatMap(nest, xs)
        end |λ|
    end script
    
    iterateUntil(p, f, {tree})
end levelNodes

-- levels :: Tree a -> [[a]]
on levels(tree)
    script nextLayer
        on |λ|(xs)
            script
                on |λ|(x)
                    nest of x
                end |λ|
            end script
            concatMap(result, xs)
        end |λ|
    end script
    
    script roots
        on |λ|(xs)
            script
                on |λ|(x)
                    root of x
                end |λ|
            end script
            map(result, xs)
        end |λ|
    end script
    
    map(roots, iterateUntil(my isNull, nextLayer, {tree}))
end levels

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

-- liftA2Fn :: (a0 -> b -> c) -> (a -> a0) -> (a -> b) -> a -> c
on liftA2Fn(op, f, g)
    -- Lift a binary function to a composition
    -- over two other functions.
    -- liftA2 (*) (+ 2) (+ 3) 7 == 90
    script go
        property mop : mReturn(op)
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            |λ|(|λ|(x) of mf, |λ|(x) of mg) of mop
        end |λ|
    end script
end liftA2Fn

-- liftA2LR :: (a -> b -> c) -> Either d a -> Either d b -> Either d c
on liftA2LR(f, a, b)
    set x to |Right| of a
    if class of b is list then
        set y to {}
    else
        set y to |Right| of b
    end if
    
    if x is missing value then
        a
    else if y is missing value then
        b
    else
        |Right|(|λ|(x, y) of mReturn(f))
    end if
end liftA2LR

-- liftA2List :: (a -> b -> c) -> [a] -> [b] -> [c]
on liftA2List(f, xs, ys)
    script
        property g : mReturn(f)'s |λ|
        on |λ|(x)
            script
                on |λ|(y)
                    {g(x, y)}
                end |λ|
            end script
            concatMap(result, ys)
        end |λ|
    end script
    concatMap(result, xs)
end liftA2List

-- liftA2May :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
on liftA2May(f, a, b)
    if Nothing of a then
        a
    else if Nothing of b then
        b
    else
        Just(|λ|(Just of a, Just of b) of mReturn(f))
    end if
end liftA2May

-- liftA2Tree :: (a -> b -> c) -> Tree a -> Tree b -> Tree c
on liftA2Tree(f, tx, ty)
    
    script fx
        on |λ|(y)
            mReturn(f)'s |λ|(root of tx, y)
        end |λ|
    end script
    
    script fmapT
        on |λ|(t)
            fmapTree(fx, t)
        end |λ|
    end script
    
    script liftA2T
        on |λ|(t)
            liftA2Tree(f, t, ty)
        end |λ|
    end script
    
    if class of ty is list then
        set rootLabel to {}
        set forest to {}
    else
        set rootLabel to root of ty
        set forest to map(fmapT, nest of ty) & map(liftA2T, nest of tx)
    end if
    
    Node(mReturn(f)'s |λ|(root of tx, rootLabel), forest)
end liftA2Tree

-- liftA2Tuple :: Monoid m => (a -> b -> c) -> (m, a) -> (m, b) -> (m, c)
on liftA2Tuple(f, a, b)
    if class of b is list then
        set b1 to {}
        set b2 to {}
    else
        set b1 to |1| of b
        set b2 to |2| of b
    end if
    Tuple(mappend(|1| of a, b1), mReturn(f)'s |λ|(|2| of a, b2))
end liftA2Tuple

-- lines :: String -> [String]
on |lines|(xs)
    paragraphs of xs
end |lines|

-- list :: Gen [a] -> [a]
on |list|(gen)
    -- A strict list derived from a lazy generator.    
    set xs to {}
    set x to |λ|() of gen
    repeat while missing value ≠ x
        set end of xs to x
        set x to |λ|() of gen
    end repeat
    return xs
end |list|

-- listDirectory :: FilePath -> [FilePath]
on listDirectory(strPath)
    set ca to current application
    unwrap(ca's NSFileManager's defaultManager()'s ¬
        contentsOfDirectoryAtPath:(unwrap(stringByStandardizingPath of ¬
            wrap(strPath))) |error|:(missing value))
end listDirectory

-- listFromMaybe :: Maybe a -> [a]
on listFromMaybe(mb)
    -- A singleton list derived from a Just value, 
    -- or an empty list derived from Nothing.
    if Nothing of mb then
        {}
    else
        {Just of mb}
    end if
end maybeToList

-- listFromTree :: Tree a -> [a]
on listFromTree(tree)
    script go
        on |λ|(x)
            {root of x} & concatMap(go, nest of x)
        end |λ|
    end script
    |λ|(tree) of go
end listFromTree

-- listFromTuple :: (a, a ...) -> [a]
on listFromTuple(tpl)
    items 2 thru -2 of (tpl as list)
end listFromTuple

-- listToMaybe :: [a] -> Maybe a
on listToMaybe(xs)
    -- The listToMaybe function returns Nothing on 
    -- an empty list or Just the head of the list.
    if xs ≠ {} then
        Just(item 1 of xs)
    else
        Nothing()
    end if
end listToMaybe

-- log :: Float -> Float
on |log|(n)
    Just of evalJSMay(("Math.log(" & n as string) & ")")
end |log|

-- lookup :: Eq a => a -> Container -> Maybe b
on lookup(k, m)
    set c to class of m
    if c is list then
        lookupTuples(k, m)
    else if c = record then
        lookupDict(k, m)
    else
        Nothing()
    end if
end lookup

-- lookupDict :: a -> Dict -> Maybe b
on lookupDict(k, dct)
    -- Just the value of k in the dictionary,
    -- or Nothing if k is not found.
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:dct)'s objectForKey:k
    if missing value ≠ v then
        Just(item 1 of ((ca's NSArray's arrayWithObject:v) as list))
    else
        Nothing()
    end if
end lookupDict

-- lookupTuples :: Eq a => a -> [(a, b)] -> Maybe b
on lookupTuples(k, xs)
    script keyMatch
        on |λ|(x)
            k = fst(x)
        end |λ|
    end script
    
    script harvestMay
        on |λ|(kv)
            Just(snd(kv))
        end |λ|
    end script
    
    bindMay(find(keyMatch, xs), harvestMay)
end lookupTuples

-- lt (<) :: Ord a => a -> a -> Boolon lt(x)	script		on |λ|(y)			x < y		end |λ|	end scriptend lt

-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper. 
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    -- 'The mapAccumL function behaves like a combination of map and foldl; 
    -- it applies a function to each element of a list, passing an 
    -- accumulating parameter from |Left| to |Right|, and returning a final 
    -- value of this accumulator together with the new list.' (see Hoogle)
    script
        on |λ|(a, x, i)
            tell mReturn(f) to set pair to |λ|(|1| of a, x, i)
            Tuple(|1| of pair, (|2| of a) & {|2| of pair})
        end |λ|
    end script
    
    foldl(result, Tuple(acc, []), xs)
end mapAccumL

-- mapAccumL_Tree :: (acc -> x -> (acc, y)) -> acc -> Tree -> (acc, Tree)
on mapAccumL_Tree(f, acc, tree)
    script go
        property mf : mReturn(f)'s |λ|
        on |λ|(a, x)
            set pair to f(a, root of x)
            set tpl to mapAccumL(go, item 1 of pair, nest of x)
            Tuple(item 1 of tpl, Node(item 2 of pair, item 2 of tpl))
        end |λ|
    end script
    |λ|(acc, tree) of go
end mapAccumL_Tree

-- mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumR(f, acc, xs)
    -- 'The mapAccumR function behaves like a combination of map and foldr; 
    --  it applies a function to each element of a list, passing an accumulating 
    --  parameter from |Right| to |Left|, and returning a final value of this 
    --  accumulator together with the new list.' (see Hoogle)
    script
        on |λ|(x, a, i)
            tell mReturn(f) to set pair to |λ|(|1| of a, x, i)
            Tuple(|1| of pair, (|2| of pair) & |2| of a)
        end |λ|
    end script
    foldr(result, Tuple(acc, []), xs)
end mapAccumR

-- mapKeys :: (Key -> Key) -> IntMap a -> IntMap a
on mapKeys(f, dct)
    script
        property g : mReturn(f)
        on |λ|(kv)
            set {k, v} to kv
            {g's |λ|(k), v}
        end |λ|
    end script
    map(result, zip(keys(dct), elems(dct)))
end mapKeys

-- mapMaybe :: (a -> Maybe b) -> [a] -> [b]
on mapMaybe(mf, xs)
    -- The mapMaybe function is a version of map which can throw out
    -- elements. In particular, the functional argument returns
    -- something of type Maybe b. If this is Nothing, no element is
    -- added on to the result list. If it just Just b, then b is
    -- included in the result list.
    script
        property g : mReturn(mf)
        on |λ|(a, x)
            set mb to g's |λ|(x)
            if Nothing of mb then
                a
            else
                a & (Just of mb)
            end if
        end |λ|
    end script
    foldl(result, {}, xs)
end mapMaybe

-- mapMaybeGen :: (a -> Maybe b) -> Gen [a] -> Gen [b]
on mapMaybeGen(mf, gen)
    script
        property mg : mReturn(mf)
        on |λ|()
            set v to gen's |λ|()
            if v is not missing value then
                set mb to mg's |λ|(v)
                repeat while (Nothing of mb) and not (missing value is v)
                    set v to gen's |λ|()
                    if missing value is not v then set mb to mg's |λ|(v)
                end repeat
                if not |Nothing| of mb then
                    |Just| of mb
                else
                    missing value
                end if
            else
                v
            end if
        end |λ|
    end script
end mapMaybeGen

-- mappend (<>) :: Monoid a => a -> a -> a
on mappend(a, b)
    set ca to class of a
    if record is ca then
        script instanceMay
            on |λ|(strType)
                set mb to lookup(strType, ¬
                    {Maybe:mappendMaybe, Ordering:mappendOrdering, Tuple:mappendTuple})
            end |λ|
        end script
        set mbi to bindMay(lookup("type", a), instanceMay)
        if Nothing of mbi then
            a & b
        else
            mReturn(Just of mbi)'s |λ|(a, b)
        end if
    else if handler is ca then
        mappendFn(a, b)
    else
        a & b
    end if
end mappend

-- mappendFn :: Monoid b => (a -> b) -> (a -> b) -> (a -> b)
on mappendFn(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mappend(mf's |λ|(x), mg's |λ|(x))
        end |λ|
    end script
end mappendFn

-- mappendMaybe (<>) :: Maybe a -> Maybe a -> Maybe a
on mappendMaybe(a, b)
    if Nothing of a then
        b
    else if Nothing of b then
        a
    else
        Just(mappend(Just of a, Just of b))
    end if
end mappendMaybe

-- mappendOrd (<>) :: Ordering -> Ordering -> Ordering
on mappendOrd(a, b)
    if 0 ≠ a then
        a
    else
        b
    end if
end mappendOrd

-- mappendTuple (<>) :: (a, b) -> (a, b) -> (a, b)
on mappendTuple(a, b)
    Tuple(mappend(|1| of a, |1| of b), mappend(|2| of a, |2| of b))
end mappendTuple

-- matching :: [a] -> (a -> Int -> [a] -> Bool)
-- matching :: String -> (Char -> Int -> String -> Bool)
on matching(pat)
    -- Returns a sequence-matching function for findIndices etc
    if class of pat is text then
        set xs to characters of pat
    else
        set xs to pat
    end if
    set lng to length of xs
    set bln to 0 < lng
    if bln then
        set h to item 1 of xs
    else
        set h to missing value
    end if
    script
        on |λ|(x, i, src)
            (h = x) and xs = ¬
                (items i thru min(length of src, -1 + lng + i) of src)
        end |λ|
    end script
end matching

-- max :: Ord a => a -> a -> a
on max(x, y)
    if gt(x, y) then
        x
    else
        y
    end if
end max

-- maxBound :: a -> a
on maxBound(x)
    set c to class of x
    if text is c then
        character id 65535
    else if integer is c then
        (2 ^ 29 - 1)
    else if real is c then
        1.797693E+308
    else if boolean is c then
        true
    end if
end maxBound

-- maximum :: Ord a => [a] -> a
on maximum(xs)
    script
        on |λ|(a, b)
            if a is missing value or b > a then
                b
            else
                a
            end if
        end |λ|
    end script
    
    foldl(result, missing value, xs)
end maximum

-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script
    
    foldl(max, missing value, xs)
end maximumBy

-- maximumByMay :: (a -> a -> Ordering) -> [a] -> Maybe a
on maximumByMay(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script
    
    foldl1May(max, xs)
end maximumByMay

-- maximumMay :: Ord a => [a] -> Maybe a
on maximumMay(xs)
    foldl1May(max, xs)
end maximumMay

-- maybe :: b -> (a -> b) -> Maybe a -> b
on maybe(v, f, mb)
    -- Either the default value v (if mb is Nothing),
    -- or the application of the function f to the 
    -- contents of the Just value in mb.
    if Nothing of mb then
        v
    else
        tell mReturn(f) to |λ|(Just of mb)
    end if
end maybe

-- mean :: [Num] -> Num
on mean(xs)
    script
        on |λ|(a, x)
            a + x
        end |λ|
    end script
    foldl(result, 0, xs) / (length of xs)
end mean

-- memberDict :: Key -> Dict -> Bool
on memberDict(k, dct)
    ((current application's ¬
        NSDictionary's dictionaryWithDictionary:dct)'s ¬
        objectForKey:k) is not missing value
end member

-- memberSet :: a -> Set a -> Bool
on memberSet(x, oSet)
    oSet's containsObject:(x)
end memberSet

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- minBound :: a -> a
on minBound(x)
    set c to class of x
    if text is c then
        character id 1
    else if integer is c then
        -(2 ^ 29 - 1)
    else if real is c then
        -1.797693E+308
    else if boolean is c then
        false
    end if
end minBound

-- minimum :: Ord a => [a] -> a
on minimum(xs)
    set lng to length of xs
    if lng < 1 then return missing value
    set m to item 1 of xs
    repeat with x in xs
        set v to contents of x
        if v < m then set m to v
    end repeat
    return m
end minimum

-- minimumBy :: (a -> a -> Ordering) -> [a] -> a
on minimumBy(f, xs)
    set lng to length of xs
    if lng < 1 then
        missing value
    else if lng > 1 then
        tell mReturn(f)
            set v to item 1 of xs
            repeat with x in xs
                if |λ|(x, v) < 0 then set v to contents of x
            end repeat
            return v
        end tell
    else
        item 1 of xs
    end if
end minimumBy

-- minimumByMay :: (a -> a -> Ordering) -> [a] -> Maybe a
on minimumByMay(f, xs)
    set lng to length of xs
    if lng < 1 then
        Nothing()
    else if lng > 1 then
        tell mReturn(f)
            set v to item 1 of xs
            repeat with x in xs
                if |λ|(x, v) < 0 then set v to contents of x
            end repeat
            return Just(v)
        end tell
    else
        Just(item 1 of xs)
    end if
end minimumByMay

-- minimumMay :: [a] -> Maybe a
on minimumMay(xs)
    set lng to length of xs
    if lng < 1 then
        Nothing()
    else if lng > 1 then
        set m to item 1 of xs
        repeat with x in xs
            set v to contents of x
            if v < m then set m to v
        end repeat
        Just(m)
    else
        Just(item 1 of xs)
    end if
end minimumMay

-- mod :: Int -> Int -> Int
on |mod|(n, d)
    if signum(n) = signum(-d) then
        (n mod d) + d
    else
        (n mod d)
    end if
end |mod|

-- modificationTime :: FilePath -> Either String Date
on modificationTime(fp)
    script fs
        on |λ|(rec)
            |Right|(NSFileModificationDate of rec)
        end |λ|
    end script
    bindLR(my fileStatus(fp), fs)
end modificationTime

-- mul (*) :: Num a => a -> a -> a
on mul(a)
    -- Curried multiplication.
    script
        on |λ|(b)
            a * b
        end |λ|
    end script
end mul

-- ne :: a -> a -> Bool
on ne(a)
    script
        on |λ|(b)
            a ≠ b
        end |λ|
    end script
end ne

-- negate :: Num -> Num
on |negate|(n)
    -n
end |negate|

-- nest :: Tree a -> [a]
on nest(oTree)
    nest of oTree
end nest

-- newUUID :: () -> IO UUID String
on newUUID()
    current application's NSUUID's UUID's UUIDString as string
end newUUID

-- not :: Bool -> Bool
on |not|(p)
    -- `not` as a composable  and mappable function.
    not p
end |not|

-- notElem :: Eq a => a -> [a] -> Bool
on notElem(x, xs)
    xs does not contain x
end notElem

-- nub :: [a] -> [a]
on nub(xs)
    nubBy(eq, xs)
end nub

-- nubBy :: (a -> a -> Bool) -> [a] -> [a]
on nubBy(f, xs)
    set g to mReturn(f)'s |λ|
    
    script notEq
        property fEq : g
        on |λ|(a)
            script
                on |λ|(b)
                    not fEq(a, b)
                end |λ|
            end script
        end |λ|
    end script
    
    script go
        on |λ|(xs)
            if (length of xs) > 1 then
                set x to item 1 of xs
                {x} & go's |λ|(filter(notEq's |λ|(x), items 2 thru -1 of xs))
            else
                xs
            end if
        end |λ|
    end script
    
    go's |λ|(xs)
end nubBy

-- odd :: Int -> Bool
on odd(x)
    not even(x)
end odd

-- on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
on |on|(f, g)
    -- e.g. sortBy(|on|(compare, |length|), ["epsilon", "mu", "gamma", "beta"])
    script
        on |λ|(a, b)
            tell mReturn(g) to set {va, vb} to {|λ|(a), |λ|(b)}
            tell mReturn(f) to |λ|(va, vb)
        end |λ|
    end script
end |on|

-- or :: [Bool] -> Bool
on |or|(ps)
    repeat with p in ps
        if p then return true
    end repeat
    return false
end |or|

-- ord :: Char -> Int
on ord(c)
    id of c
end ord

-- ordering :: () -> Ordering
on ordering()
    enumFromPairs("Ordering", {{"LT", -1}, {"EQ", 0}, {"GT", 1}})
end ordering

-- All lines in the string outdented by the same amount
-- (just enough to ensure that the least indented lines 
--  have no remaining indent)
-- All relative indents are left unchanged
-- outdented :: String -> String
on outdented(s)
    set xs to |lines|(s)
    script dent
        on |λ|(x)
            script isSpace
                on |λ|(c)
                    id of c = 32
                end |λ|
            end script
            length of takeWhile(isSpace, x)
        end |λ|
    end script
    set n to |λ|(minimumBy(comparing(dent), xs)) of dent
    if n < 1 then
        s
    else
        unlines(map(|λ|(n) of curry(drop), xs))
    end if
end outdented

-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(f, xs)
    tell mReturn(f)
        set ys to {}
        set zs to {}
        repeat with x in xs
            set v to contents of x
            if |λ|(v) then
                set end of ys to v
            else
                set end of zs to v
            end if
        end repeat
    end tell
    Tuple(ys, zs)
end partition

-- partitionEithers :: [Either a b] -> ([a],[b])
on partitionEithers(xs)
    set ys to {}
    set zs to {}
    repeat with x in xs
        if isRight(x) then
            set end of zs to x
        else
            set end of ys to x
        end if
    end repeat
    Tuple(ys, zs)
end partitionEithers

-- permutations :: [a] -> [[a]]
on permutations(xs)
    script go
        on |λ|(x, a)
            script
                on |λ|(ys)
                    script infix
                        on |λ|(n)
                            if ys ≠ {} then
                                take(n, ys) & x & drop(n, ys)
                            else
                                {x}
                            end if
                        end |λ|
                    end script
                    map(infix, enumFromTo(0, (length of ys)))
                end |λ|
            end script
            concatMap(result, a)
        end |λ|
    end script
    foldr(go, {{}}, xs)
end permutations

-- permutationsWithRepetition :: Int -> [a] -> [[a]]
on permutationsWithRepetition(n, xs)
    if 0 < length of xs then
        foldl1(curry(my cartesianProduct)'s |λ|(xs), replicate(n, xs))
    else
        {}
    end if
end permutationsWithRepetition

-- pi :: Float
on |pi|()
    pi
end |pi|

-- plus :: Num -> Num -> Num
on plus(a, b)
    a + b
end plus

-- Root elements of tree flattened bottom-up
-- into a postorder list.
-- postorder :: Tree a -> [a]
on postorder(node)
    script go
        on |λ|(xs, x)
            foldl(go, xs, nest of x) & {root of x}
        end |λ|
    end script
    go's |λ|({}, node)
end postorder

-- pred :: Enum a => a -> a
on pred(x)
    if isChar(x) then
        chr(ord(x) - 1)
    else
        (-1) + x
    end if
end pred

-- predMay :: Enum a => a -> Maybe a
on predMay(x)
    if x is minBound(x) then
        Nothing()
    else
        Just(toEnum(x)'s |λ|(fromEnum(x) - 1))
    end if
end predMay

-- print :: a -> IO ()
on print (x)
    log x
    return x
end print

-- product :: [Num] -> Num
on product(xs)
    script multiply
        on |λ|(a, b)
            a * b
        end |λ|
    end script
    
    foldl(multiply, 1, xs)
end product

-- properFracRatio :: Ratio -> (Int, Ratio)
on properFracRatio(r)
    set n to n of r
    set d to d of r
    Tuple(n div d, ratio(n mod d, d))
end properFracRatio

-- properFraction :: Real -> (Int, Real)
on properFraction(n)
    set i to (n div 1)
    Tuple(i, n - i)
end properFraction

-- pureLR :: a -> Either e a
on pureLR(x)
    |Right|(x)
end pureLR

-- pureList :: a -> [a]
on pureList(x)
        {x}
end pure

-- pureMay :: a -> Maybe a
on pureMay(x)
    Just(x)
end pureMay

-- Given a type name string, returns a 
-- specialised 'pure', where
-- 'pure' lifts a value into a particular functor.
-- pureT :: String -> f a -> (a -> f a)
on pureT(t, x)
    if "List" = t then
        pureList(x)
    else if "Either" = t then
        pureLR(x)
    else if "Maybe" = t then
        pureMay(x)
    else if "Node" = t then
        pureTree(x)
    else if "Tuple" = t then
        pureTuple(x)
    else
        pureList(x)
    end if
end pureT

-- pureTree :: a -> Tree a
on pureTree(x)
    Node(x, {})
end pureTree

-- pureTuple :: a -> (a, a)
on pureTuple(x)
    Tuple("", x)
end pureTuple

-- quickSort :: (Ord a) => [a] -> [a]
on quickSort(xs)
    -- Adequate for small sorts, but sort (Ord a => [a] -> [a]), (which uses the ObjC
    -- sortedArrayUsingSelector) is the one to use
    if length of xs > 1 then
        set h to item 1 of xs
        script
            on |λ|(x)
                x ≤ h
            end |λ|
        end script
        set {less, more} to partition(result, rest of xs)
        quickSort(less) & h & quickSort(more)
    else
        xs
    end if
end quickSort

-- quickSortBy :: (a -> a -> Ordering) -> [a] -> [a]
on quickSortBy(cmp, xs)
    -- quickSortBy(comparing(my |length|), 
    -- {"alpha", "beta", "gamma", "delta", "epsilon", "zeta", 
    --  "eta", "theta", "iota", "kappa", "lambda", "mu"})
    if length of xs > 1 then
        set h to item 1 of xs
        script
            on |λ|(x)
                cmp's |λ|(x, h) ≠ 1
            end |λ|
        end script
        set {less, more} to partition(result, rest of xs)
        quickSortBy(cmp, less) & h & quickSortBy(cmp, more)
    else
        xs
    end if
end quickSortBy

-- quot :: Int -> Int -> Int
on quot(m, n)
    m div n
end quot

-- quotRem :: Int -> Int -> (Int, Int)
on quotRem(m, n)
    Tuple(m div n, m mod n)
end quotRem

-- quoted :: Char -> String -> String
on quoted(c)
    -- A string flanked on both sides
    -- by a specified quote character.
    script
        on |λ|(s)
            c & s & c
        end |λ|
    end script
end quoted

-- radians :: Float x => Degrees x -> Radians x
on radians(x)
    (pi / 180) * x
end radians

-- raise :: Num -> Int -> Num
on raise(m, n)
    m ^ n
end raise

-- e.g. map(randomRInt(1, 10), ft(1, 20))
-- randomRInt :: Int -> Int -> IO () -> Int
on randomRInt(low, high)
    script
        on |λ|(_)
            (low + ((random number) * (1 + (high - low)))) div 1
        end |λ|
    end script
end randomRInt

-- range :: Ix a => (a, a) -> [a]
on range(ab)
    set {a, b} to {|1| of ab, |2| of ab}
    if class of a is list then
        set {xs, ys} to {a, b}
    else
        set {xs, ys} to {{a}, {b}}
    end if
    set lng to length of xs
    
    if lng = length of ys then
        if lng > 1 then
            script
                on |λ|(_, i)
                    enumFromTo(item i of xs, item i of ys)
                end |λ|
            end script
            sequence(map(result, xs))
        else
            enumFromTo(a, b)
        end if
    else
        {}
    end if
end range

-- ratio :: Int -> Int -> Ratio Int
on ratio(x, y)
    script go
        on |λ|(x, y)
            if 0 ≠ y then
                if 0 ≠ x then
                    set d to gcd(x, y)
                    {type:"Ratio", n:(x div d), d:(y div d)}
                else
                    {type:"Ratio", n:0, d:0}
                end if
            else
                missing value
            end if
        end |λ|
    end script
    go's |λ|(x * (signum(y)), abs(y))
end ratio

-- ratioDiv :: Rational -> Rational -> Rational
on ratioDiv(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    ratio((n of r1) * (d of r2), (d of r1) * (n of r2))
end ratioDiv

-- ratioMinus :: Rational -> Rational -> Rational
on ratioMinus(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    set d to lcm(d of r1, d of r2)
    ratio((n of r1) * (d / (d of r1) - ¬
        ((n of r2) * (d / (d of r2)))), d)
end ratioMinus

-- ratioMult :: Rational -> Rational -> Rational
on ratioMult(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    ratio((n of r1) * (n of r2), (d of r1) * (d of r2))
end ratioMult

-- ratioPlus :: Rational -> Rational -> Rational
on ratioPlus(n1, n2)
    set r1 to rational(n1)
    set r2 to rational(n2)
    set d to lcm(d of r1, d of r2)
    ratio((n of r1) * (d / (d of r1) + ¬
        ((n of r2) * (d / (d of r2)))), d)
end ratioPlus

-- rational :: Num a => a -> Rational
on rational(x)
    set c to class of x
    if integer is c then
        ratio(x, 1)
    else if real is c then
        approxRatio(missing value, x)
    else
        x
    end if
end rational

-- read :: Read a => String -> a
on read (s)
    run script s
end read

-- readFile :: FilePath -> IO String
on readFile(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if missing value is e then
        s as string
    else
        (localizedDescription of e) as string
    end if
end readFile

-- readFileLR :: FilePath -> Either String IO String
on readFileLR(strPath)
    set ca to current application
    set e to reference
    set {s, e} to (ca's NSString's ¬
        stringWithContentsOfFile:((ca's NSString's ¬
            stringWithString:strPath)'s ¬
            stringByStandardizingPath) ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(e))
    if s is missing value then
        |Left|((localizedDescription of e) as string)
    else
        |Right|(s as string)
    end if
end readFileLR

-- readHex :: String -> Int
on readHex(s)
    -- The integer value of the given hexadecimal string.
    set ds to "0123456789ABCDEF"
    script go
        on |λ|(c, a)
            set {v, e} to a
            set i to maybe(0, my identity, elemIndex(c, ds))
            {v + (i * e), 16 * e}
        end |λ|
    end script
    item 1 of foldr(go, {0, 1}, characters of s)
end readHex

-- readLR :: Read a => String -> Either String a
on readLR(s)
    try
        |Right|(run script s)
    on error e
        |Left|(e)
    end try
end readLR

-- recip :: Num -> Num
on recip(n)
    if n ≠ 0 then
        1 / n
    else
        missing value
    end if
end recip

-- recipMay :: Num -> Maybe Num
on recipMay(n)
    if n ≠ 0 then
        Just(1 / n)
    else
        Nothing()
    end if
end recipMay

-- regexMatches :: Regex String -> String -> [[String]]on regexMatches(strRegex, strHay)	set ca to current application	-- NSNotFound handling and and High Sierra workaround due to @sl1974	set NSNotFound to a reference to 9.22337203685477E+18 + 5807	set oRgx to ca's NSRegularExpression's regularExpressionWithPattern:strRegex ¬		options:((ca's NSRegularExpressionAnchorsMatchLines as integer)) ¬		|error|:(missing value)	set oString to ca's NSString's stringWithString:strHay		script matchString		on |λ|(m)			script rangeMatched				on |λ|(i)					tell (m's rangeAtIndex:i)						set intFrom to its location						if NSNotFound ≠ intFrom then							text (intFrom + 1) thru (intFrom + (its |length|)) of strHay						else							missing value						end if					end tell				end |λ|			end script		end |λ|	end script		script asRange		on |λ|(x)			range() of x		end |λ|	end script	map(asRange, (oRgx's matchesInString:oString ¬		options:0 range:{location:0, |length|:oString's |length|()}) as list)end regexMatches

-- rem :: Int -> Int -> Int
on rem(m, n)
    m mod n
end rem

-- removeFile :: FilePath -> Either String String
on removeFile(fp)
    set e to reference
    set {bln, obj} to current application's NSFileManager's ¬
        defaultManager's removeItemAtPath:(fp) |error|:(e)
    if bln then
        |Right|("Removed: " & fp)
    else
        |Left|(obj's localizedDescription as string)
    end if
end removeFile

-- renamedFile :: FilePath -> FilePath ->
-- Either IO String IO String
on renamedFile(fp, fp2)
    set e to reference
    set {bln, obj} to current application's NSFileManager's ¬
        defaultManager's moveItemAtPath:(fp) toPath:(fp2) |error|:(e)
    if bln then
        |Right|(fp2)
    else
        |Left|(obj's localizedDescription as string)
    end if
end renameFile

-- repeat :: a -> Generator [a]
on |repeat|(x)
    script
        on |λ|()
            return x
        end |λ|
    end script
end |repeat|

-- replace :: String -> String -> String -> String
on replace(strNeedle, strNew, strHayStack)
    set {dlm, my text item delimiters} to {my text item delimiters, strNeedle}
    set xs to text items of strHayStack
    set my text item delimiters to strNew
    set strReplaced to xs as text
    set my text item delimiters to dlm
    return strReplaced
end replace

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary 
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list, 
    -- appending stages of doubling to an accumulator where needed 
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script
    
    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script
    
    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate

-- Instance for lists only here

-- e.g. replicateM(3, {1, 2})) -> 
-- {{1, 1, 1}, {1, 1, 2}, {1, 2, 1}, {1, 2, 2}, {2, 1, 1}, 
--  {2, 1, 2}, {2, 2, 1}, {2, 2, 2}}
-- replicateM :: Int -> [a] -> [[a]]
on replicateM(n, xs)
    script go
        script cons
            on |λ|(a, bs)
                {a} & bs
            end |λ|
        end script
        on |λ|(x)
            if x ≤ 0 then
                {{}}
            else
                liftA2List(cons, xs, |λ|(x - 1))
            end if
        end |λ|
    end script
    
    go's |λ|(n)
end replicateM

-- replicateString :: Int -> String -> String
on replicateString(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s
 
    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicateS

-- reverse :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|

-- rights :: [Either a b] -> [b]
on rights(xs)
    script
        on |λ|(x)
            if class of x is record then
                set ks to keys(x)
                if ks contains "type" and ks contains "Right" then
                    {|Right| of x}
                else
                    {}
                end if
            else
                {}
            end if
        end |λ|
    end script
    concatMap(result, xs)
end rights

-- root :: Tree a -> a
on root(oTree)
    root of oTree
end root

-- rotate :: Int -> [a] -> [a]
on rotate(n, xs)
    set lng to |length|(xs)
    if missing value is not lng then
        take(lng, drop(lng - n, cycle(xs)))
    else
        lng
    end if
end rotate

-- round :: a -> Int
on |round|(n)
    round n
end |round|

-- Float x rounded to n decimals
-- roundTo :: Int -> Float -> Floaton roundTo(n, x)	set d to 10 ^ n	(round (x * d)) / dend roundTo

-- runAction :: Action a -> a
on runAction(act)
    -- Evaluation of an action.
    tell act to |λ|(its arg) of my mReturn(its act)
end runAction

-- safeMay :: (a -> Bool) -> (a -> b) -> Maybe b
on safeMay(p, f, x)
    if p(x) then
        Just(f(x))
    else
        Nothing()
    end if
end safeMay

-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
on scanl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return lst
    end tell
end scanl

-- scanl1 :: (a -> a -> a) -> [a] -> [a]
on scanl1(f, xs)
    if 0 < length of xs then
        scanl(f, item 1 of xs, rest of xs)
    else
        {}
    end if
end scanl

-- scanr :: (b -> a -> b) -> b -> [a] -> [b]
on scanr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return reverse of lst
    end tell
end scanr

-- scanr1 :: (a -> a -> a) -> [a] -> [a]
on scanr1(f, xs)
    if length of xs > 0 then
        scanr(f, item -1 of xs, init(xs))
    else
        {}
    end if
end scanr1

-- second :: (a -> b) -> ((c, a) -> (c, b))
on |second|(f)
-- Lift a simple function to one which applies to a tuple, 
-- transforming only the second item of that tuple
    script
        on |λ|(xy)
            Tuple(|1| of xy, mReturn(f)'s |λ|(|2| of xy))
        end |λ|
    end script
end |second|

-- sequenceA :: (Applicative f, Traversable t) => t (f a) -> f (t a)
on sequenceA(tfa)
    script identity
        on |λ|(x)
            x
        end |λ|
    end script
    traverse(identity, tfa)
end sequenceA

-- setCurrentDirectory :: String -> IO ()
on setCurrentDirectory(strPath)
    if doesDirectoryExist(strPath) then
        set ca to current application
        set oPath to (ca's NSString's stringWithString:strPath)'s ¬
            stringByStandardizingPath
        ca's NSFileManager's defaultManager()'s ¬
            changeCurrentDirectoryPath:oPath
    end if
end setCurrentDirectory

-- setFromList :: Ord a => [a] -> Set a
on setFromList(xs)
    -- NB All names of NSMutableSets should be set to *missing value*
    -- before the script exits.
    -- ( scpt files can not be saved if they contain ObjC pointer values)
    set ca to current application
    ca's NSMutableSet's ¬
        setWithArray:(ca's NSArray's arrayWithArray:(xs))
end setFromList

-- setInsert :: Ord a => a -> Set a -> Set a
on setInsert(x, objcSet)
    objcSet's addObject:(x)
    objcSet
end setInsert

-- setMember :: Ord a => a -> Set a -> Bool
on setMember(x, objcSet)
    missing value is not (objcSet's member:(x))
end setMember

-- setSize :: Set a -> Int
on setSize(objcSet)
    objcSet's |count|() as integer
end setSize

-- shift :: Int -> [a] -> [a]
on shift(n, xs)
    set lng to |length|(xs)
    if missing value is not lng then
        take(lng, drop(n, cycle(xs)))
    else
        drop(n, xs)
    end if
end shift

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        showList(e)
    else if c = record then
        set mb to lookupDict("type", e)
        if Nothing of mb then
            showDict(e)
        else
            script
                on |λ|(t)
                    if "Either" = t then
                        set f to my showLR
                    else if "Maybe" = t then
                        set f to my showMaybe
                    else if "Ordering" = t then
                        set f to my showOrdering
                    else if "Ratio" = t then
                        set f to my showRatio
                    else if class of t is text and t begins with "Tuple" then
                        set f to my showTuple
                    else
                        set f to my showDict
                    end if
                    tell mReturn(f) to |λ|(e)
                end |λ|
            end script
            tell result to |λ|(Just of mb)
        end if
    else if c = date then
        "\"" & showDate(e) & "\""
    else if c = text then
        "'" & e & "'"
    else if (c = integer or c = real) then
        e as text
    else if c = class then
        "null"
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- showBinary :: Int -> String
on showBinary(n)
    script binaryChar
        on |λ|(n)
            text item (n + 1) of "01"
        end |λ|
    end script
    showIntAtBase(2, binaryChar, n, "")
end showBin

-- ISO 8601 UTC 
-- showDate :: Date -> String
on showDate(dte)
    ((dte - (time to GMT)) as «class isot» as string) & ".000Z"
end showDate

-- showDict :: Dict -> String
on showDict(dct)
  showJSON(dct)
end showDict

-- showForest :: [Tree a] -> String
on showForest(xs)
    unlines(map(my showTree, xs))
end showForest

-- showHex :: Int -> String
on showHex(n)
    showIntAtBase(16, mReturn(intToDigit), n, "")
end showHex

-- showIntAtBase :: Int -> (Int -> Char) -> Int -> String -> String
on showIntAtBase(base, toDigit, n, rs)
    script showIt
        property f : mReturn(toDigit)
        on |λ|(nd_, r)
            set {n, d} to ({|1|, |2|} of nd_)
            set r_ to f's |λ|(d) & r
            if n > 0 then
                |λ|(quotRem(n, base), r_)
            else
                r_
            end if
        end |λ|
    end script
    showIt's |λ|(quotRem(n, base), rs)
end showIntAtBase

-- showJSON :: a -> String
on showJSON(x)
    set c to class of x
    if (c is list) or (c is record) then
        set ca to current application
        set {json, e} to ca's NSJSONSerialization's dataWithJSONObject:x options:1 |error|:(reference)
        if json is missing value then
            e's localizedDescription() as text
        else
            (ca's NSString's alloc()'s initWithData:json encoding:(ca's NSUTF8StringEncoding)) as text
        end if
    else if c is date then
        "\"" & ((x - (time to GMT)) as «class isot» as string) & ".000Z" & "\""
    else if c is text then
        "\"" & x & "\""
    else if (c is integer or c is real) then
        x as text
    else if c is class then
        "null"
    else
        try
            x as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end showJSON

-- showLR :: Either a b -> String
on showLR(lr)
    if isRight(lr) then
        "Right(" & unQuoted(show(|Right| of lr)) & ")"
    else
        "Left(" & unQuoted(show(|Left| of lr)) & ")"
    end if
end showLR

-- showList :: [a] -> String
on showList(xs)
    "[" & intercalateS(", ", map(my show, xs)) & "]"
end showList

-- showLog :: a -> IO ()
on showLog(e)
    log show(e)
end showLog

-- showMaybe :: Maybe a -> String
on showMaybe(mb)
    if Nothing of mb then
        "Nothing"
    else
        "Just " & unQuoted(show(Just of mb))
    end if
end showMaybe

-- showOrdering :: Ordering -> String
on showOrdering(e)
    set v to value of e
    if v > 0 then
        "GT"
    else if v < 0 then
        "LT"
    else
        "EQ"
    end if
end showOrdering

-- showOutline :: Tree String -> String
on showOutline(x)
    script go
        on |λ|(indent)
            script
                on |λ|(tree)
                    {indent & (root of tree)} & ¬
                        concatMap(go's |λ|(tab & indent), ¬
                            nest of tree)
                end |λ|
            end script
        end |λ|
    end script
    unlines((go's |λ|(""))'s |λ|(x))
end showOutline

-- showPrecision :: Int -> Float -> String
on showPrecision(n, x)
    set d to 10 ^ n
    ((round (x * d)) / d) as string
end showPrecision

-- showRatio :: Ratio -> String
on showRatio(r)
    set s to (n of r as string)
    set d to d of r
    if 1 ≠ d then
        s & "/" & (d as string)
    else
        s
    end if
end showRatio

-- showSet :: Set a -> String
on showSet(s)
    script str
        on |λ|(x)
            x as string
        end |λ|
    end script
    "{" & intercalate(", ", map(str, sort(elems(s)))) & "}"
end showSet

-- showTree :: Tree a -> String
on showTree(tree)
    script str
        on |λ|(x)
            x as string
        end |λ|
    end script
    drawTree2(false, true, fmapTree(str, tree))
end showTree

-- showTuple :: Tuple -> String
on showTuple(tpl)
    set ca to current application
    script
        on |λ|(n)
            set v to (ca's NSDictionary's dictionaryWithDictionary:tpl)'s objectForKey:(n as string)
            if v ≠ missing value then
                unQuoted(show(item 1 of ((ca's NSArray's arrayWithObject:v) as list)))
            else
                missing value
            end if
        end |λ|
    end script
    "(" & intercalateS(", ", map(result, enumFromTo(1, length of tpl))) & ")"
end showTuple

-- showUndefined :: () -> String
on showUndefined()
    "⊥"
end showUndefined

-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum

-- Abbreviation for quick testing
-- sj :: a -> String
on sj(x)
    showJSON(x)
end sj

-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd

-- Mirror image of cons
-- New copy of the list, with an atom added at the end
-- snoc :: [a] -> a -> [a]
on snoc(xs, x)
    xs & {x}
end snoc

-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- sortBy :: (a -> a -> Ordering) -> [a] -> [a]
on sortBy(f, xs)
    -- Enough for small scale sorts.
    -- Use instead sortOn (Ord b => (a -> b) -> [a] -> [a])
    -- which is equivalent to the more flexible sortBy(comparing(f), xs)
    -- and uses a much faster ObjC NSArray sort method
    if length of xs > 1 then
        set h to item 1 of xs
        set f to mReturn(f)
        script
            on |λ|(x)
                f's |λ|(x, h) ≤ 0
            end |λ|
        end script
        set lessMore to partition(result, rest of xs)
        sortBy(f, |1| of lessMore) & {h} & ¬
            sortBy(f, |2| of lessMore)
    else
        xs
    end if
end sortBy

-- sortOn :: Ord b => (a -> b) -> [a] -> [a]-- sortOn :: Ord b => [((a -> b), Bool)]  -> [a] -> [a]on sortOn(f, xs)	-- Sort a list by comparing the results of a key function applied to each	-- element. sortOn f is equivalent to sortBy(comparing(f), xs), but has the	-- performance advantage of only evaluating f once for each element in	-- the input list. This is called the decorate-sort-undecorate paradigm,	-- or Schwartzian transform.	-- Elements are arranged from from lowest to highest.		-- In this Applescript implementation, f can optionally be [(a -> b)]	-- or [((a -> b), Bool)]) to specify a compound sort order		--    xs:  List of items to be sorted. 	--          (The items can be records, lists, or simple values).	--	--    f:    A single (a -> b) function (Applescript handler),	--          or a list of such functions.	--          if the argument is a list, any function can 	--          optionally be followed by a bool. 	--          (False -> descending sort)	--	--          (Subgrouping in the list is optional and ignored)	--          Each function (Item -> Value) in the list should 	--          take an item (of the type contained by xs) 	--          as its input and return a simple orderable value 	--          (Number, String, or Date).	--	--          The sequence of key functions and optional 	--          direction bools defines primary to N-ary sort keys.	script keyBool		on |λ|(x, a)			if boolean is class of x then				{asc:x, fbs:fbs of a}			else				{asc:true, fbs:({Tuple(x, asc of a)} & fbs of a)}			end if		end |λ|	end script	set {fs, bs} to {|1|, |2|} of unzip(fbs of foldr(keyBool, ¬		{asc:true, fbs:{}}, flatten({f})))		set intKeys to length of fs	set ca to current application	script dec		property gs : map(my mReturn, fs)		on |λ|(x)			set nsDct to (ca's NSMutableDictionary's ¬				dictionaryWithDictionary:{val:x})			repeat with i from 1 to intKeys				(nsDct's setValue:((item i of gs)'s |λ|(x)) ¬					forKey:(character id (96 + i)))			end repeat			nsDct as record		end |λ|	end script		script descrip		on |λ|(bool, i)			ca's NSSortDescriptor's ¬				sortDescriptorWithKey:(character id (96 + i)) ¬					ascending:bool		end |λ|	end script		script undec		on |λ|(x)			val of x		end |λ|	end script		map(undec, ((ca's NSArray's arrayWithArray:map(dec, xs))'s ¬		sortedArrayUsingDescriptors:map(descrip, bs)) as list)end sortOn

-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(p, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs)) 
    script go
        property f : mReturn(p)
        on |λ|(cs)
            if {} ≠ cs then
                set c to item 1 of cs
                if |λ|(c) of p then
                    set {ys, zs} to go's |λ|(rest of cs)
                    {{c} & ys, zs}
                else
                    {{}, cs}
                end if
            else
                {}
            end if
        end |λ|
    end script
    |λ|(xs) of go
end span

-- splitArrow (***) :: (a -> b) -> (c -> d) -> ((a, c) -> (b, d))
on splitArrow(f, g)
    -- Compose a function (from a tuple to a tuple), 
    -- (with separate transformations for fst and snd)
    script
        on |λ|(xy)
            Tuple(mReturn(f)'s |λ|(|1| of xy), mReturn(g)'s |λ|(|2| of xy))
        end |λ|
    end script
end splitArrow

-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt

-- splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
-- splitBy :: (String -> String -> Bool) -> String -> [String]
on splitBy(p, xs)
    if 2 > length of xs then
        {xs}
    else
        script pairMatch
            property mp : mReturn(p)'s |λ|
            on |λ|(a, b)
                {mp(a, b), a, b}
            end |λ|
        end script
        
        script addOrSplit
            on |λ|(a, blnXY)
                set {bln, x, y} to blnXY
                if bln then
                    {item 1 of a & {item 2 of a}, {y}}
                else
                    {item 1 of a, (item 2 of a) & y}
                end if
            end |λ|
        end script
        set {a, r} to foldl(addOrSplit, ¬
            {{}, {item 1 of xs}}, ¬
            zipWith(pairMatch, xs, rest of xs))
        
        if list is class of xs then
            a & {r}
        else
            map(my concat, a & {r})
        end if
    end if
end splitBy

-- splitFileName :: FilePath -> (String, String)
on splitFileName(strPath)
    -- Split a filename into directory and file. combine is the inverse.
    if strPath ≠ "" then
        if last character of strPath ≠ "/" then
            set xs to splitOn("/", strPath)
            set stem to init(xs)
            if stem ≠ {} then
                Tuple(intercalate("/", stem) & "/", |last|(xs))
            else
                Tuple("./", |last|(xs))
            end if
        else
            Tuple(strPath, "")
        end if
    else
        Tuple("./", "")
    end if
end splitFileName

-- splitOn :: [a] -> [a] -> [[a]]
-- splitOn :: String -> String -> [String]
on splitOn(pat, src)
    -- splitOn("\r\n", "a\r\nb\r\nd\r\ne") --> ["a","b","d","e"]
    -- splitOn("aaa", "aaaXaaaXaaaXaaa") --> {"", "X", "X", "X", ""}
    -- splitOn("x", "x") --> {"", ""}
    -- splitOn([3, 1], [1, 2, 3, 1, 2, 3, 1, 2, 3])
    --> {{1, 2}, {2}, {2, 3}}
    if class of src is text then
        set {dlm, my text item delimiters} to ¬
            {my text item delimiters, pat}
        set xs to text items of src
        set my text item delimiters to dlm
        return xs
    else
        set lng to length of pat
        script residue
            on |λ|(a, i)
                Tuple(fst(a) & ¬
                    {init(items snd(a) thru (i) of src)}, lng + i)
            end |λ|
        end script
        set tpl to foldl(residue, ¬
            Tuple({}, 1), findIndices(matching(pat), src))
        return fst(tpl) & {drop(snd(tpl) - 1, src)}
    end if
end splitOn

-- splitRegex :: Regex -> String -> [String]
on splitRegex(strRegex, str)
    set lstMatches to regexMatches(strRegex, str)
    if length of lstMatches > 0 then
        script preceding
            on |λ|(a, x)
                set iFrom to start of a
                set iLocn to (location of x)
                
                if iLocn > iFrom then
                    set strPart to text (iFrom + 1) thru iLocn of str
                else
                    set strPart to ""
                end if
                {parts:parts of a & strPart, start:iLocn + (length of x) - 1}
            end |λ|
        end script
        
        set recLast to foldl(preceding, {parts:[], start:0}, lstMatches)
        
        set iFinal to start of recLast
        if iFinal < length of str then
            parts of recLast & text (iFinal + 1) thru -1 of str
        else
            parts of recLast & ""
        end if
    else
        {str}
    end if
end splitRegex

-- sqrt :: Num -> Num
on sqrt(n)
    if 0 <= n then
        n ^ (1 / 2)
    else
        missing value
    end if
end sqrt

-- sqrtLR :: Num -> Either String Num
on sqrtLR(n)
    if 0 ≤ n then
        |Right|(n ^ (1 / 2))
    else
        |Left|("Square root of negative number: " & n)
    end if
end sqrtLR

-- sqrtMay :: Num -> Maybe Num
on sqrtMay(n)
    if n ≥ 0 then
        Just(n ^ (1 / 2))
    else
        Nothing()
    end if
end sqrtMay

-- str :: a -> String
on str(x)
    x as string
end str

-- strip :: String -> String
on strip(s)
    script isSpace
        on |λ|(c)
            set i to id of c
            32 = i or (9 ≤ i and 13 ≥ i)
        end |λ|
    end script
    dropWhile(isSpace, dropWhileEnd(isSpace, s))
end strip

-- stripEnd :: String -> String
on stripEnd(s)
    dropWhileEnd(my isSpace, s)
end stripEnd

-- stripPrefix :: Eq a => [a] -> [a] -> Maybe [a]
-- stripPrefix :: String -> String -> Maybe String
on stripPrefix(pfx, s)
    set blnString to class of pfx is text
    if blnString then
        set {xs, ys} to {characters of pfx, characters of s}
    else
        set {xs, ys} to {pfx, s}
    end if
    
    script
        on |λ|(xs, ys)
            if length of xs < 1 then
                if blnString then
                    set v to intercalate("", ys)
                else
                    set v to ys
                end if
                Just(v)
            else
                if (length of ys < 1) or (item 1 of xs ≠ item 1 of ys) then
                    Nothing()
                else
                    |λ|(tail(xs), tail(ys))
                end if
            end if
        end |λ|
    end script
    |λ|(xs, ys) of result
end stripPrefix

-- stripStart :: String -> String
on stripStart(s)
    dropWhile(my isSpace, s)
end stripStart

-- subTreeAtPath :: Tree String -> [String] -> Maybe Tree String
on subTreeAtPath(tree, pathSegments)
    script go
        on |λ|(children, xs)
            if {} ≠ children and {} ≠ xs then
                set h to item 1 of xs
                script parentMatch
                    on |λ|(t)
                        h = root of t
                    end |λ|
                end script
                script childMatch
                    on |λ|(t)
                        if 1 < length of xs then
                            |λ|(nest of t, rest of xs) of go
                        else
                            Just(t)
                        end if
                    end |λ|
                end script
                bindMay(find(parentMatch, children), childMatch)
            else
                Nothing()
            end if
        end |λ|
    end script
    |λ|({tree}, pathSegments) of go
end subTreeAtPath

-- subsequences :: [a] -> [[a]]
-- subsequences :: String -> [String]
on subsequences(xs)
    -- subsequences([1,2,3]) -> [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
    -- subsequences("abc") -> ["","a","b","ab","c","ac","bc","abc"]
    script nonEmptySubsequences
        on |λ|(xxs)
            if length of xxs < 1 then
                {}
            else
                set {x, xs} to {item 1 of xxs, tail(xxs)}
        
                script f
                    on |λ|(ys, r)
                        cons(ys, cons(cons(x, ys), r))
                    end |λ|
                end script
                
                cons({x}, foldr(f, {}, |λ|(xs) of nonEmptySubsequences))
            end if
        end |λ|
    end script
    if class of xs is text then
        cons("", map(my concat, |λ|(characters of xs) of nonEmptySubsequences))
    else
        cons([], |λ|(xs) of nonEmptySubsequences)
    end if
end subsequences

-- subsets :: [a] -> [[a]]
on subsets(xs)
    script go
        on |λ|(ys)
            if 0 < length of ys then
                set h to item 1 of ys
                set zs to |λ|(rest of ys)
                script hcons
                    on |λ|(z)
                        {h} & z
                    end |λ|
                end script
                zs & map(hcons, zs)
            else
                {{}}
            end if
        end |λ|
    end script
    go's |λ|(xs)
end subsets

-- subtract :: Num -> Num -> Num
on subtract(x, y)
    y - x
end subtract

-- succ :: Enum a => a -> a
on succ(x)
    if isChar(x) then
        chr(1 + ord(x))
    else
        1 + x
    end if
end succ

-- succMay :: Enum a => a -> Maybe a
on succMay(x)
    if x is maxBound(x) then
        Nothing()
    else
        Just(toEnum(x)'s |λ|(fromEnum(x) + 1))
    end if
end succMay

-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script
    
    foldl(add, 0, xs)
end sum

-- swap :: (a, b) -> (b, a)
on swap(ab)
    if class of ab is record then
        Tuple(|2| of ab, |1| of ab)
    else
        {item 2 of ab, item 1 of ab}
    end if
end swap

-- tail :: [a] -> [a]
on tail(xs)
    set blnText to text is class of xs
    if blnText then
        set unit to ""
    else
        set unit to {}
    end if
    set lng to length of xs
    if 1 > lng then
        missing value
    else if 2 > lng then
        unit
    else
        if blnText then
            text 2 thru -1 of xs
        else
            rest of xs
        end if
    end if
end tail

-- tailMay :: [a] -> Maybe [a]
on tailMay(xs)
    if xs = {} then
        Nothing()
    else
        Just(rest of xs)
    end if
end tailMay

-- tails :: [a] -> [[a]]
on tails(xs)
    if class of xs is text then
        set es to characters of xs
    else
        set es to xs
    end if
    script residue
        on |λ|(_, i)
            items i thru -1 of es
        end |λ|
    end script
    map(residue, es) & {{}}
end tails

-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to |λ|() of xs
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take

-- takeAround :: (a -> Bool) -> [a] -> [a]
on takeAround(p, xs)
    set ys to takeWhile(p, xs)
    if length of ys < length of xs then
        ys & takeWhileR(p, xs)
    else
        ys
    end if
end takeAround

-- takeBaseName :: FilePath -> String
on takeBaseName(strPath)
    if "" ≠ strPath then
        if "/" = text -1 of strPath then
            ""
        else
            set fn to item -1 of splitOn("/", strPath)
            if fn contains "." then
                intercalate(".", items 1 thru -2 of splitOn(".", fn))
            else
                fn
            end if
        end if
    else
        ""
    end if
end takeBaseName

-- takeCycle :: Int -> [a] -> [a]
on takeCycle(n, xs)
    set lng to length of xs
    if lng ≥ n then
        set cycle to xs
    else
        set cycle to concat(replicate((n div lng) + 1, xs))
    end if
    
    if class of xs is string then
        items 1 thru n of cycle as string
    else
        items 1 thru n of cycle
    end if
end takeCycle

-- takeDirectory :: FilePath -> FilePath
on takeDirectory(fp)
    set strPath to filePath(fp)
    if "" ≠ strPath then
        if "/" = character -1 of strPath then
            text 1 thru -2 of strPath
        else
            set xs to init(splitOn("/", strPath))
            if {} ≠ xs then
                intercalateS("/", xs)
            else
                "."
            end if
        end if
    else
        "."
    end if
end takeDirectory

-- take N Members of an infinite cycle of xs, starting from index I
-- takeDropCycle :: Int -> [a] -> [a]
on takeDropCycle(n, i, xs)
    set lng to length of xs
    set m to n + i
    
    if lng ≥ m then
        set ys to xs
    else
        set ys to concat(replicate(ceiling(m / lng), xs))
    end if
    
    drop(i, take(m, ys))
end takeDropCycle

-- takeExtension :: FilePath -> String
on takeExtension(strPath)
    set xs to splitOn(".", strPath)
    if 1 < length of xs then
        "." & item -1 of xs
    else
        ""
    end if
end takeExtension

-- takeFileName :: FilePath -> FilePath
on takeFileName(strPath)
    if "" ≠ strPath and "/" ≠ character -1 of strPath then
        item -1 of splitOn("/", strPath)
    else
        ""
    end if
end takeFileName

-- takeFromThenTo :: Int -> Int -> Int -> [a] -> [a]
on takeFromThenTo(a, b, z, xs)
    script go
        on |λ|(i)
            item (1 + i) of xs
        end |λ|
    end script
    map(go, enumFromThenTo(a, b, z))
end takeFromThenTo

-- takeIterate n f x == [x, f x, f (f x), ...]
-- takeIterate :: Int -> (a -> a) -> a -> [a]
on takeIterate(n, f, x)
    set v to x
    set vs to {v}
    tell mReturn(f)
        repeat with i from 1 to n - 1
            set v to |λ|(v)
            set end of vs to v
        end repeat
    end tell
    return vs
end takeIterate

-- takeWhile :: (a -> Bool) -> [a] -> [a]
-- takeWhile :: (Char -> Bool) -> String -> String
on takeWhile(p, xs)
    if script is class of xs then
        takeWhileGen(p, xs)
    else
        tell mReturn(p)
            repeat with i from 1 to length of xs
                if not |λ|(item i of xs) then ¬
                    return take(i - 1, xs)
            end repeat
        end tell
        return xs
    end if
end takeWhile

-- takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
on takeWhileGen(p, xs)
    set ys to {}
    set v to |λ|() of xs
    tell mReturn(p)
        repeat while (|λ|(v))
            set end of ys to v
            set v to xs's |λ|()
        end repeat
    end tell
    return ys
end takeWhileGen

-- takeWhileR :: (a -> Bool) -> [a] -> [a]
on takeWhileR(p, xs)
    set bln to false
    set blnText to (class of xs) is text
    tell mReturn(p)
        set lng to length of xs
        repeat with i from lng to 1 by -1
            if not |λ|(item i of xs) then
                set bln to true
                exit repeat
            end if
        end repeat
    end tell
    if bln then
        if i > 1 then
            if blnText then
                text (1 + i) thru (-1) of xs
            else
                items (1 + i) thru (-1) of xs
            end if
        else
            if blnText then
                ""
            else
                {}
            end if
        end if
    else
        xs
    end if
end takeWhileR

-- taskPaperDateString :: Date -> String
on taskPaperDateString(dte)
    set {d, t} to splitOn("T", dte as «class isot» as string)
    d & space & text 1 thru 5 of t
end taskPaperDateString

-- tempFilePath :: String -> IO FilePath
on tempFilePath(template)
    (current application's ¬
        NSTemporaryDirectory() as string) & ¬
        takeBaseName(template) & ¬
        text 3 thru -1 of ((random number) as string) & ¬
        takeExtension(template)
end tempFilePath

-- toEnum :: a -> Int -> a
on toEnum(e)
    script
        property c : class of e
        on |λ|(x)
            if integer is c or real is c then
                x as number
            else if text is c then
                character id x
            else if boolean is c then
                if 0 ≠ x then
                    true
                else
                    false
                end if
            end if
        end |λ|
    end script
end toEnum

-- toLower :: String -> String
on toLower(str)
    -- String in lower case. 
    tell current application
        ((its (NSString's stringWithString:(str)))'s ¬
            lowercaseStringWithLocale:(its NSLocale's currentLocale())) as text
    end tell
end toLower

-- toRatio :: Real -> Ratio
on toRatio(n)
    approxRatio(1.0E-12, n)
end toRatio

-- Sentence case - initial string capitalized and rest lowercase
-- toSentence :: String -> String
on toSentence(str)
    set ca to current application
    if length of str > 0 then
        set locale to ca's NSLocale's currentLocale()
        set ws to ca's NSString
        (((ws's stringWithString:(text 1 of str))'s ¬
            uppercaseStringWithLocale:(locale)) as text) & ¬
            ((ws's stringWithString:(text 2 thru -1 of str))'s ¬
                lowercaseStringWithLocale:(locale)) as text
    else
        str
    end if
end toSentence

-- NB this does not model any regional or cultural conventions.
-- It simply simply capitalizes the first character of each word.
-- toTitle :: String -> String
on toTitle(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toTitle

-- toUpper :: String -> String
on toUpper(str)
    tell current application
        ((its (NSString's stringWithString:(str)))'s ¬
            uppercaseStringWithLocale:(its NSLocale's currentLocale())) as text
    end tell
end toUpper

-- transpose :: [[a]] -> [[a]]
on transpose(xxs)
    -- If some of the rows are shorter than the following rows, 
    -- their elements are skipped:
    -- transpose({{10,11},{20},{},{30,31,32}}) -> {{10, 20, 30}, {11, 31}, {32}}
    set intMax to |length|(maximumBy(comparing(my |length|), xxs))
    set gaps to replicate(intMax, {})
    script padded
        on |λ|(xs)
            set lng to |length|(xs)
            if lng < intMax then
                xs & items (lng + 1) thru -1 of gaps
            else
                xs
            end if
        end |λ|
    end script
    set rows to map(padded, xxs)
    
    script cols
        on |λ|(_, iCol)
            script cell
                on |λ|(row)
                    item iCol of row
                end |λ|
            end script
            concatMap(cell, rows)
        end |λ|
    end script
    map(cols, item 1 of rows)
end transpose

-- Simplified version - assuming rows of unvarying length.
-- transpose_ :: [[a]] -> [[a]]on transpose_(rows)	script cols		on |λ|(_, iCol)			script cell				on |λ|(row)					item iCol of row				end |λ|			end script			concatMap(cell, rows)		end |λ|	end script	map(cols, item 1 of rows)end transpose_

-- traverse :: (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b)
on traverse(f, tx)
    if class of tx is list then
        traverseList(f, tx)
    else if class of tx is record and keys(tx) contains "type" then
        set t to type of tx
        if "Either" = t then
            traverseLR(f, tx)
        else if "Maybe" = t then
            traverseMay(f, tx)
        else if "Node" = t then
            traverseTree(f, tx)
        else if "Tuple" = t then
            traverseTuple(f, tx)
        else
            missing value
        end if
    else
        missing value
    end if
end traverse

-- traverseLR :: Applicative f => (t -> f b) -> Either a t -> f (Either a b)
on traverseLR(f, lr)
    if |Left| of lr is not missing value then
        {lr}
    else
        fmap(my |Right|, mReturn(f)'s |λ|(|Right| of lr))
    end if
end traverseLR

--    1. Map each element of a structure to an action,
--    2. evaluate these actions from left to right, and
--    3. collect the results.
-- 
--    traverse f = List.foldr cons_f (pure [])
--      where cons_f x ys = liftA2 (:) (f x) ys
-- traverseList :: (Applicative f) => (a -> f b) -> [a] -> f [b]
on traverseList(f, xs)
    set lng to length of xs
    if 0 < lng then
        set mf to mReturn(f)
        
        set vLast to mf's |λ|(item -1 of xs)
        if class of vLast is record and ¬
            keys(vLast) contains "type" then
            set t to type of vLast
        else
            set t to "List"
        end if
        
        script cons_f
            on |λ|(x, ys)
                liftA2(my cons, mf's |λ|(x), ys)
            end |λ|
        end script
        
        foldr(cons_f, ¬
            liftA2(my cons, vLast, pureT(t, [])), ¬
            init(xs))
    else
        {{}}
    end if
end traverseList

-- traverseMay :: Applicative f => (t -> f a) -> Maybe t -> f (Maybe a)
on traverseMay(f, mb)
    if Nothing of mb then
        {mb}
    else
        fmap(my Just, mReturn(f)'s |λ|(Just of mb))
    end if
end traverseMay

-- traverseTree :: Applicative f => (a -> f b) -> Tree a -> f (Tree b)
on traverseTree(f, tree)
    -- traverse f (Node x ts) = liftA2 Node (f x) (traverse (traverse f) ts)
    script go
        on |λ|(x)
            liftA2(my Node, ¬
                mReturn(f)'s |λ|(root of x), ¬
                traverseList(go, nest of x))
        end |λ|
    end script
    go's |λ|(tree)
end traverseTree

-- traverseTuple :: Functor f => (t -> f b) -> (a, t) -> f (a, b)
on traverseTuple(f, tpl)
    fmap(curry(my Tuple)'s |λ|(|1| of tpl), ¬
        mReturn(f)'s |λ|(|2| of tpl))
end traverseTuple

-- treeFromDict :: String -> Dict -> Tree String
on treeFromDict(treeTitle, recDict)
    script go
        on |λ|(x)
            set c to class of x
            if list is c then
                script
                    on |λ|(v)
                        Node(v, {})
                    end |λ|
                end script
                map(result, x)
            else if record is c then
                script
                    on |λ|(k)
                        Node(k, go's |λ|(|Just| of lookupDict(k, x)))
                    end |λ|
                end script
                map(result, keys(x))
            else
                {}
            end if
        end |λ|
    end script
    Node(treeTitle, go's |λ|(recDict))
end treeFromDict

-- treeFromNestedList :: NestedList a -> Tree a
on treeFromNestedList(vxs)
    script go
        on |λ|(pair)
            Node(item 1 of pair, map(go, item 2 of pair))
        end |λ|
    end script
    |λ|(vxs) of go
end treeFromPairNest

-- treeLeaves :: Tree -> [Tree]
on treeLeaves(oNode)
    script go
        on |λ|(x)
            set lst to nest of x
            if 0 < length of lst then
                concatMap(my treeLeaves, lst)
            else
                {x}
            end if
        end |λ|
    end script
    |λ|(oNode) of go
end treeLeaves

-- A list of all nodes in the tree which match 
-- a predicate p.
-- For the first match only, see findTree.
-- treeMatches :: (a -> Bool) -> Tree a -> [Tree a]
on treeMatches(p, tree)
    script go
        property pf : mReturn(p)'s |λ|
        on |λ|(x)
            if pf(root of x) then
                {x}
            else
                concatMap(go, nest of x)
            end if
        end |λ|
    end script
    go's |λ|(tree)
end treeMatches

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

-- truncate :: Num -> Int
on truncate(x)
    item 1 of properFraction(x)
end truncate

-- tupleFromList :: [a] -> (a, a ...)
on tupleFromList(xs)
    set lng to length of xs
    if 1 < lng then
        if 2 < lng then
            set strSuffix to lng as string
        else
            set strSuffix to ""
        end if
        script kv
            on |λ|(a, x, i)
                insertDict((i as string), x, a)
            end |λ|
        end script
        foldl(kv, {type:"Tuple" & strSuffix}, xs) & {length:lng}
    else
        missing value
    end if
end tupleFromList

-- typeName :: a -> String
on typeName(x)
    set mb to lookupDict((class of x) as string, ¬
        {|list|:"List", |integer|:"Int", |real|:"Float", |text|:¬
            "String", |string|:"String", |record|:¬
            "Record", |boolean|:"Bool", |handler|:"(a -> b)", |script|:"(a -> b"})
    if Nothing of mb then
        "Bottom"
    else
        set k to Just of mb
        if k = "Record" then
            if keys(x) contains "type" then
                type of x
            else
                "Dict"
            end if
        else
            k
        end if
    end if
end typeName

-- unDigits :: [Int] -> Int
on unDigits(ds)
    -- The integer with the given digits.
    script go
        on |λ|(a, x)
            10 * a + x
        end |λ|
    end script
    foldl(go, 0, ds)
end unDigits

-- unQuoted :: String -> String
on unQuoted(s)
    script p
        on |λ|(x)
            --{34, 39} contains id of x
            34 = id of x
        end |λ|
    end script
    dropAround(p, s)
end unQuoted

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to |length|(xs)
    if 0 = lng then
        Nothing()
    else
        if (2 ^ 29 - 1) as integer > lng then
            if class of xs is string then
                set cs to text items of xs
                Just(Tuple(item 1 of cs, rest of cs))
            else
                Just(Tuple(item 1 of xs, rest of xs))
            end if
        else
            set nxt to take(1, xs)
            if {} is nxt then
                Nothing()
            else
                Just(Tuple(item 1 of nxt, xs))
            end if
        end if
    end if
end uncons

-- Given a curried/default function, returns an
-- equivalent function on a tuple or list pair.
-- A function over a pair, derived from
-- a function over two arguments.
-- uncurry :: (a -> b -> c) -> ((a, b) -> c)
on uncurry(f)
    if 1 < argvLength(f) then
        script
            on |λ|(ab)
                if class of ab is list then
                    mReturn(f)'s |λ|(item 1 of ab, item 2 of ab)
                else
                    mReturn(f)'s |λ|(|1| of ab, |2| of ab)
                end if
            end |λ|
        end script
    else
        script
            on |λ|(ab)
                if class of ab is list then
                    f's |λ|(item 1 of ab)'s |λ|(item 2 of ab)
                else
                    f's |λ|(|1| of ab)'s |λ|(|2| of ab)
                end if
            end |λ|
        end script
    end if
end uncurry


-- unfoldForest :: (b -> (a, [b])) -> [b] -> [Tree]
on unfoldForest(f, xs)
    -- | Build a forest from a list of seed values
    set g to mReturn(f)
    script
        on |λ|(x)
            unfoldTree(g, x)
        end |λ|
    end script
    map(result, xs)
end unfoldForest

-- | Build a tree from a seed value
-- unfoldTree :: (b -> (a, [b])) -> b -> Tree a
on unfoldTree(f, b)
    set g to mReturn(f)
    set tpl to g's |λ|(b)
    Node(|1| of tpl, unfoldForest(g, |2| of tpl))
end unfoldTree

-- unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
on unfoldl(f, v)
    -- > unfoldl (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
    -- > [1,2,3,4,5,6,7,8,9,10]
    set xr to Tuple(v, v) -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(|2| of xr)
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set xs to ({|1| of xr} & xs)
            end if
        end repeat
    end tell
    return xs
end unfoldl

-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A list obtained from a simple value.
    -- Dual to foldr.
    -- unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
    -- -> [10,9,8,7,6,5,4,3,2,1] 
    set xr to {v, v} -- (value, remainder)
    set xs to {}
    tell mReturn(f)
        repeat -- Function applied to remainder.
            set mb to |λ|(snd(xr))
            if Nothing of mb then
                exit repeat
            else -- New (value, remainder) tuple,
                set xr to Just of mb
                -- and value appended to output list.
                set end of xs to fst(xr)
            end if
        end repeat
    end tell
    return xs
end unfoldr

-- union :: [a] -> [a] -> [a]
on union(xs, ys)
    script flipDelete
        on |λ|(xs, x)
            my |delete|(x, xs)
        end |λ|
    end script
    
    set sx to nub(xs)
    sx & foldl(flipDelete, nub(ys), sx)
end union

-- unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
on unionBy(fnEq, xs, ys)
    script flipDeleteByEq
        on |λ|(xs, x)
            deleteBy(fnEq, x, xs)
        end |λ|
    end script
    xs & foldl(flipDeleteByEq, nubBy(fnEq, ys), xs)
end unionBy

-- unionSet :: Ord a => Set a -> Set a -> Set a
on unionSet(s, s1)
    set sUnion to current application's NSMutableSet's alloc's init()
    sUnion's setSet:(s)
    sUnion's unionSet:(s1)
    return sUnion
end unionSet

-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines

-- If the list is empty returns Nothing, otherwise returns 
-- Just the init and the last.
-- unsnoc :: [a] -> Maybe ([a], a)
on unsnoc(xs)
    set blnString to class of xs is string
    set lng to length of xs
    if lng = 0 then
        Nothing()
    else
        set h to item -1 of xs
        if lng > 1 then
            if blnString then
                Just(Tuple(text 1 thru -2 of xs, h))
            else
                Just(Tuple(items 1 thru -2 of xs, h))
            end if
        else
            if blnString then
                Just(Tuple("", h))
            else
                Just(Tuple({}, h))
            end if
        end if
    end if
end unsnoc

-- until :: (a -> Bool) -> (a -> a) -> a -> aon |until|(p, f, x)	set v to x	set mp to mReturn(p)	set mf to mReturn(f)	repeat until mp's |λ|(v)		set v to mf's |λ|(v)	end repeat	vend |until|

-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords

-- unwrap :: NSObject -> a
on unwrap(objCValue)
    if objCValue is missing value then
        missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:objCValue) as list)
    end if
end unwrap

-- unzip :: [(a,b)] -> ([a],[b])
on unzip(xys)
    set xs to {}
    set ys to {}
    repeat with xy in xys
        set end of xs to |1| of xy
        set end of ys to |2| of xy
    end repeat
    return Tuple(xs, ys)
end unzip

-- unzip3 :: [(a,b,c)] -> ([a],[b],[c])
on unzip3(xyzs)
    set xs to {}
    set ys to {}
    set zs to {}
    repeat with xyz in xyzs
        set end of xs to |1| of xyz
        set end of ys to |2| of xyz
        set end of zs to |3| of xyz
    end repeat
    return TupleN({xs, ys, zs})
end unzip3

-- unzip4 :: [(a,b,c,d)] -> ([a],[b],[c],[d])
on unzip4(wxyzs)
    set ws to {}
    set xs to {}
    set ys to {}
    set zs to {}
    repeat with wxyz in wxyzs
        set end of ws to |1| of wxyz
        set end of xs to |2| of wxyz
        set end of ys to |3| of wxyz
        set end of zs to |4| of wxyz
    end repeat
    return TupleN({ws, xs, ys, zs})
end unzip4

-- unzipN :: [(a,b,...)] -> ([a],[b],...)
on unzipN(tpls)
    if 0 < length of tpls then
        set xs to replicate(length of item 1 of tpls, {})
        script go
            on |λ|(a, tpl)
                script inner
                    on |λ|(x, i)
                        x & Just of lookupDict(i as string, tpl)
                    end |λ|
                end script
                map(inner, a)
            end |λ|
        end script
        foldl(go, xs, tpls)
    else
        missing value
    end if
end unzipN

-- variance :: [Num] -> Num
on variance(xs)
    set m to mean(xs)
    script
        on |λ|(a, x)
            a + (x - m) ^ 2
        end |λ|
    end script
    foldl(result, 0, xs) / ((length of xs) - 1)
end variance

-- words :: String -> [String]
on |words|(s)
    set ca to current application
    (((ca's NSString's stringWithString:(s))'s ¬
        componentsSeparatedByCharactersInSet:(ca's ¬
            NSCharacterSet's whitespaceAndNewlineCharacterSet()))'s ¬
        filteredArrayUsingPredicate:(ca's ¬
            NSPredicate's predicateWithFormat:"0 < length")) as list
end |words|

-- wrap :: a -> NSObject
on wrap(v)
    set ca to current application
    ca's (NSArray's arrayWithObject:v)'s objectAtIndex:0
end wrap

-- use framework "Foundation"
-- writeFile :: FilePath -> String -> IO ()
on writeFile(strPath, strText)
    set ca to current application
    (ca's NSString's stringWithString:strText)'s ¬
        writeToFile:(stringByStandardizingPath of ¬
            (ca's NSString's stringWithString:strPath)) atomically:true ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(missing value)
end writeFile

-- writeFileLR :: FilePath -> Either String IO FilePath
on writeFileLR(strPath, strText)
    set ca to current application
    set fp to stringByStandardizingPath of ¬
        (ca's NSString's stringWithString:strPath)
    set {bln, e} to (ca's NSString's stringWithString:strText)'s ¬
        writeToFile:(fp) atomically:true ¬
            encoding:(ca's NSUTF8StringEncoding) |error|:(reference)
    if bln and (missing value is e) then
        |Right|(fp as string)
    else
        |Left|(e's localizedDescription() as string)
    end if
end writeFileLR

use framework "Foundation"
-- File name template -> string data -> temporary path
-- (Random digit sequence inserted between template base and extension)
-- writeTempFile :: String -> String -> IO FilePath
on writeTempFile(template, txt)
    set strPath to (current application's ¬
        NSTemporaryDirectory() as string) & ¬
        takeBaseName(template) & ¬
        text 3 thru -1 of ((random number) as string) & ¬
        takeExtension(template)
    -- Effect
    writeFile(strPath, txt)
    -- Value
    strPath
end writeTempFile

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    zipWith(Tuple, xs, ys)
end zip

-- zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
on zip3(xs, ys, zs)
    script
        on |λ|(x, i)
            TupleN({x, item i of ys, item i of zs})
        end |λ|
    end script
    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip3

-- zip4 :: [a] -> [b] -> [c] -> [d] -> [(a, b, c, d)]
on zip4(ws, xs, ys, zs)
    script
        on |λ|(w, i)
            TupleN({w, item i of xs, item i of ys, item i of zs})
        end |λ|
    end script
    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip4

-- zipGen :: Gen [a] -> Gen [b] -> Gen [(a, b)]
on zipGen(ga, gb)
    script
        property ma : missing value
        property mb : missing value
        on |λ|()
            if missing value is ma then
                set ma to uncons(ga)
                set mb to uncons(gb)
            end if
            if Nothing of ma or Nothing of mb then
                missing value
            else
                set ta to Just of ma
                set tb to Just of mb
                set x to Tuple(|1| of ta, |1| of tb)
                set ma to uncons(|2| of ta)
                set mb to uncons(|2| of tb)
                return x
            end if
        end |λ|
    end script
end zipGen

-- zipList :: [a] -> [b] -> [(a, b)]
on zipList(xs, ys)
    set lng to min(length of xs, length of ys)
    script go
        on |λ|(x, i)
            {x, item i of ys}
        end |λ|
    end script
    map(go, items 1 thru lng of xs)
end zipList

-- Arbitrary number of lists to zip
-- all enclosed in an argument vector list
-- zipN :: [a] -> [b] -> ... -> [(a, b ...)]
on zipN(argv)
    if 1 < length of argv then
        script go
            on |λ|(x, i)
                script peers
                    on |λ|(y)
                        item i of y
                    end |λ|
                end script
                tupleFromList(map(peers, argv))
            end |λ|
        end script
        map(go, take(minimum(map(my |length|, argv)), ¬
            item 1 of argv))
    else
        argv
    end if
end zipN

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(|length|(xs), |length|(ys))
    if 1 > lng then return {}
    set xs_ to take(lng, xs) -- Allow for non-finite
    set ys_ to take(lng, ys) -- generators like cycle etc
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs_, item i of ys_)
        end repeat
        return lst
    end tell
end zipWith

-- zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
on zipWith3(f, xs, ys, zs)
    set lng to minimum({length of xs, length of ys, length of zs})
    if 1 > lng then return {}
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys, item i of zs)
        end repeat
        return lst
    end tell
end zipWith3

-- zipWith4 :: (a -> b -> c -> d -> e) -> [a] -> [b] -> [c] -> [d] -> [e]
on zipWith4(f, ws, xs, ys, zs)
    set lng to minimum({length of ws, length of xs, length of ys, length of zs})
    if 1 > lng then return {}
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of ws, item i of xs, item i of ys, item i of zs)
        end repeat
        return lst
    end tell
end zipWith4

-- zipWithGen :: (a -> b -> c) -> Gen [a] -> Gen [b] -> Gen [c]
on zipWithGen(f, ga, gb)
    script
        property ma : missing value
        property mb : missing value
        property mf : mReturn(f)
        on |λ|()
            if missing value is ma then
                set ma to uncons(ga)
                set mb to uncons(gb)
            end if
            if Nothing of ma or Nothing of mb then
                missing value
            else
                set ta to Just of ma
                set tb to Just of mb
                set ma to uncons(|2| of ta)
                set mb to uncons(|2| of tb)
                |λ|(|1| of ta, |1| of tb) of mf
            end if
        end |λ|
    end script
end zipWithGen

-- zipWithList :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWithList(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    if 1 > lng then
        return {}
    else
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to |λ|(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWithList

-- zipWithM :: Applicative m => (a -> b -> m c) -> [a] -> [b] -> m [c]
on zipWithM(fm, xs, ys)
    -- A functor of the type to which fm lifts its result.
    -- For example, Nothing/Left if any of the zip applications failed,
    -- or Just/Right a list of the results, when all succeeded.
    traverseList(my identity, zipWith(fm, xs, ys))
end zipWithM

-- zipWithN :: (a -> b -> ... -> c) -> ([a], [b] ...) -> [c]
on zipWithN(f, rows)
    -- f applied to each tuple formed by the
    -- zipping together of each list in rows
    script go
        property mf : mReturn(f)
        on |λ|(i)
            script nth
                on |λ|(row)
                    item i of row
                end |λ|
            end script
            mf's |λ|(map(nth, rows))
        end |λ|
    end script
    map(go, enumFromTo(1, minimum(map(my |length|, rows))))
end zipWithN
