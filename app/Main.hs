module Main where

import Control.Concurrent.Chan
import Control.Exception
import Data.Char
import Data.List.Extra
import Interact
import System.Environment

main :: IO ()
main = (interactions !!) . (`mod` 8) 
   =<< list (return 0) (((return . read) .) . const)
   =<< getArgs 

interactions :: [IO ()]
interactions = [foo, foo', bar, bar', baz, baz', qux, qux']

toUpperCase :: [String] -> [String]
toUpperCase = map upcase

upcase :: String -> String
upcase = show . map (ord . toUpper)

toUpperCaseWithPrompt :: Prompt -> [String] -> [String]
toUpperCaseWithPrompt prompt = (prompt :) . map ((++ '\n':prompt) . upcase) 

foo :: IO ()
foo = genericInteract inputLines 
                      outputLines 
                      toUpperCase

foo' :: IO ()
foo' = genericInteract inputLines 
                       outputLinesWithPrompt
                       (toUpperCaseWithPrompt "? ")

bar :: IO ()
bar = genericInteract (inputLines' defaultInputConfig) 
                      outputLines
                      toUpperCase

bar' :: IO ()
bar' = genericInteract (inputLines' defaultInputConfig)
                       outputLinesWithPrompt
                       (toUpperCaseWithPrompt "? ")

baz :: IO ()
baz = do
    { chan <- newChan
    ; genericInteract inputLines
                      (outputLines' chan)
                      toUpperCase
    }
baz' :: IO ()
baz' = do
    { chan <- newChan
    ; genericInteract inputLines
                      (outputLinesWithPrompt' chan) 
                      (toUpperCaseWithPrompt "? ") 
    }

qux :: IO ()
qux = do
    { chan <- newChan
    ; genericInteract (inputLines' defaultInputConfig)
                      (outputLines' chan)
                      toUpperCase
    }

qux' :: IO ()
qux' = do
    { chan <- newChan
    ; genericInteract (inputLines' defaultInputConfig)
                      (outputLinesWithPrompt' chan)
                      (toUpperCaseWithPrompt "? ")
    }
