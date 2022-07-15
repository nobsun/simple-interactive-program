module Main where

import Data.Char
import System.Environment ( getArgs )
import Data.List.Extra
import Transition ( responser )
import Interact ( interactWithPrompt
                , interactWithPrompt'
                )

-- main :: IO ()
-- main = interactWithPrompt "? " ":quit" . responser =<< list (return "") (const . readFile) =<< getArgs

main :: IO ()
main = interactWithPrompt' "? " ":quit" sample

sample :: [String] -> [String]
sample = ((toUpper <$>) <$>)

