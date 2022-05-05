module Main where

import System.Environment ( getArgs )
import Data.List.Extra
import Lib ( someFunc )

main :: IO ()
main = interact . someFunc =<< list (return "") (const . readFile) =<< getArgs
