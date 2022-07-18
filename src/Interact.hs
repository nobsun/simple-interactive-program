module Interact
    ( InputConfig (..)
    , interact
    , interact'
    ) where

import Prelude hiding ( interact )
import Control.Concurrent
import Control.Concurrent.Chan
import Control.Exception
import Data.Bool
import Data.Maybe
import System.IO.Unsafe
import System.Console.Haskeline

type Prompt        = String
type Quit          = String
type History       = Maybe FilePath

data InputConfig   
    = InputConfig
    { prompt :: Prompt
    , quit   :: Quit
    , history :: History
    }
type Dialogue a b  = [a] -> [b]

interact :: InputConfig
         -> Dialogue String String 
         -> IO ()
interact config dialogue
    = putStr . unlines . dialogue =<< inputLines config

inputLines :: InputConfig -> IO [String]
inputLines config 
    = unsafeInterleaveIO
    $ do
    { minput <- runInputT (defaultSettings { historyFile = history config})
                          (getInputLine (prompt config))
    ; case minput of
        Nothing -> return []
        Just line 
            | line == quit config -> return []
            | otherwise           -> (line :) <$> inputLines config
    }

type Render a = Chan a -> IO ()

interact' :: InputConfig 
           -> Chan String
           -> Chan a
           -> Dialogue String a 
           -> Render a
           -> IO ()
interact' config req res dialogue render = do
    { pid <- forkIO (inputLines' config req)
    ; qid <- forkIO (writeList2Chan res . dialogue =<< getChanContents req)
    ; render res
    }

inputLines' :: InputConfig -> Chan String -> IO ()
inputLines' config chan
    = maybe (return ())
            (\ line -> bool (return ()) (writeChan chan line >> inputLines' config chan) (line /= quit config))
    =<< runInputT (defaultSettings { historyFile = history config}) (getInputLine (prompt config))
