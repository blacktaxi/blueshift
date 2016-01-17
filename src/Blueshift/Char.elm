module Blueshift.Char where

import Blueshift.Core exposing (..)
import String

anyChar : Parser Char
anyChar = Parser <| \inp ->
  case String.uncons inp of
    Just (c, tail) -> Ok (c, tail)
    Nothing -> Err <| errMsgExpected "any character" inp

satisfy : (Char -> Bool) -> Parser Char
satisfy pred =
  anyChar `andThen` \c ->
    if pred c
      then succeed c
      else fail ("no sat for " ++ String.fromChar c)

char : Char -> Parser Char
char c = satisfy ((==) c) `annotate` ("'" ++ String.fromChar c ++ "'")

notChar : Char -> Parser Char
notChar c = satisfy ((/=) c)

anyOf : String -> Parser Char
anyOf s = satisfy (\x -> String.fromChar x `String.contains` s)

noneOf : String -> Parser Char
noneOf s = satisfy (\x -> not <| String.fromChar x `String.contains` s)

string : String -> Parser String
string s =
  let p = Parser <| \inp ->
    if String.left (String.length s) inp == s
      then Ok (s, String.dropLeft (String.length s) inp)
      else Err ""
  in p `annotate` ("'" ++ s ++ "'")

-- anyString : Parser String
-- anyString = Parser <| \inp ->
