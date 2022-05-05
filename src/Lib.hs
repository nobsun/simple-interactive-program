{-# LANGUAGE EmptyDataDecls #-}
module Lib
    ( someFunc
    ) where

import Data.Maybe

{- | 
任意の入力列をそれぞれの入力文字列を"なんか関数"に変換
>>> putStr $ someFunc undefined "Hi."
なんか関数
-}
someFunc :: String -> String -> String
someFunc = drive . responser

drive :: ([String] -> [String]) -> (String -> String)
drive f = unlines . f . lines

responser :: String -> [String] -> [String]
responser extra = mapMaybe output . eval . initial extra

data State
    = State 
    { inChan :: [String]
    , output :: Maybe String
    , innerState :: InnerState
    }

data InnerState

initial :: String -> [String] -> State
initial extra inputs
    = State { inChan = inputs
            , output = Nothing
            , innerState = error "initial is not implemented" extra
            }

eval :: State -> [State]
eval state = state : rests
    where
        rests | isFinal state = []
              | otherwise     = eval (step state)

isFinal :: State -> Bool
isFinal state = case state of
    State { inChan = [] } -> True
    _                     -> False

step :: State -> State
step state = case state of
    State { inChan = i : is
          , innerState = instate
          } -> state { inChan = is
                     , innerState = undefined
                     , output = Just "なんか関数"
                     }
