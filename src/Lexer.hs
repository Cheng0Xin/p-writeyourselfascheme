module Lexer (
  LispVal (..),
  readExpr
) where

import Text.ParserCombinators.Parsec hiding (spaces)


data LispVal = Atom String
  | List [LispVal]
  | DottedList [LispVal] LispVal
  | Number Integer
  | String String
  | Bool Bool
  deriving (Show)

spaces :: Parser Char
spaces = space <|> oneOf "\t\n\r\\"

readExpr :: String -> String
readExpr x = case parse (skipMany spaces >> parseExpr) "Lisp > " x of 
  Right x -> show x
  Left err -> "Not found, " ++ show err

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

escapedChars :: Parser Char
escapedChars = char '\\' >> oneOf "\\\""
  

parseString :: Parser LispVal
parseString = do
  char '"'
  x <- many $ noneOf "\"\\" <|> escapedChars
  char '"'
  return $ String x

parseNumber :: Parser LispVal
parseNumber = many1 digit >>= (return . Number .read)
