```applescript
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
```