module Lib
    ( someFunc
    ) where

{- | 
任意の入力列をそれぞれの入力文字列を"なんか関数"に変換
>>> putStr $ someFunc "Hi."
なんか関数
-}
someFunc :: String -> String
someFunc = drive responser

responser :: [String] -> [String]
responser = map (const "なんか関数")

drive :: ([String] -> [String]) -> (String -> String)
drive f = unlines . f . lines
