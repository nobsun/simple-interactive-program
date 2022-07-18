module Main where

import Control.Concurrent.Chan
import Control.Exception
import Data.Char
import Interact ( InputConfig (..), interact' ) 
import Transition ( responder )

main :: IO ()
main = do 
    { req <- newChan
    ; res <- newChan
    ; catch (interact' (InputConfig "? " ":quit" Nothing) req res sample ((putStr . unlines =<<) . getChanContents))
            (\ BlockedIndefinitelyOnMVar -> return ())
    }

sample :: [String] -> [String]
sample = ((toUpper <$>) <$>)
