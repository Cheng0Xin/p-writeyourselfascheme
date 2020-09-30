module Core ( 
  mainFunc
) where

import System.Environment

import Lexer

mainFunc :: IO ()
mainFunc = getArgs >>= putStrLn . readExpr . head
