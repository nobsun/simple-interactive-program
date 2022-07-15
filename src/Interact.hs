module Interact
    ( interactWithPrompt
    , interactWithPrompt'
    ) where

import Control.Concurrent
import Control.Concurrent.Chan
import System.IO.Unsafe
import System.Console.Haskeline

interactWithPrompt :: String -> String -> ([String] -> [String]) -> IO ()
interactWithPrompt prompt quit f 
    = putStr . unlines . f =<< loop
    where
        loop :: IO [String]
        loop = unsafeInterleaveIO $ do
            { minput <- runInputT defaultSettings (getInputLine prompt)
            ; case minput of
                Nothing   -> return []
                Just line
                    | line == quit -> return []
                    | otherwise    -> (line :) <$> loop
            }

interactWithPrompt' :: String -> String -> ([String] -> [String]) -> IO ()
interactWithPrompt' prompt quit f = do
    { o   <- newChan
    ; tid <- forkIO (g o)
    ; putStr . unlines =<< getChanContents o
    }
    where
        g    :: Chan String -> IO ()
        g o  = writeList2Chan o . f =<< loop
        loop :: IO [String]
        loop = unsafeInterleaveIO $ do
            { minput <- runInputT defaultSettings (getInputLine prompt)
            ; case minput of
                Nothing   -> return []
                Just line
                    | line == quit -> return []
                    | otherwise    -> (line :) <$> loop
            }