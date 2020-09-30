module Lexer (
  LispVal (..),
  readExpr
) where

import Text.ParserCombinators.Parsec


data LispVal = Atom String
  | List [LispVal]
  | DottedList [LispVal] LispVal
  | Number Integer
  | String String
  | Bool Bool
  deriving (Show)

readExpr :: String -> String
readExpr x = case parse parseExpr "" x of 
  Right x -> show x
  _ -> "Not found"

parseExpr :: Parser LispVal
parseExpr = parseAtom
  <|> parseNumber
  <|> parseString

symbol :: Parser Char
symbol = oneOf "!#$%&|*+-/:<=>?@^_~"

parseAtom :: Parser LispVal
parseAtom = do
  first <- letter <|> symbol
  rest <- many $ letter <|> symbol <|> digit
  let atom = first:rest
  return $ case atom of 
    "#t" -> Bool True
    "#f" -> Bool False
    _ -> Atom atom

parseString :: Parser LispVal
parseString = do
  char '"'
  x <- many $ noneOf "\""
  char '"'
  return $ String x

parseNumber :: Parser LispVal
parseNumber = many1 digit >>= (return . Number .read)
