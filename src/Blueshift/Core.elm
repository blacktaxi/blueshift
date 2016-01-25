module Blueshift.Core where

import String

type Parser a =
  Parser (String -> Result String (a, String))

runParser : Parser a -> String -> Result String (a, String)
runParser (Parser run) inp = run inp

parse : Parser a -> String -> Result String a
parse p inp =
  case runParser p inp of
    Ok (x, _) -> Ok x
    Err err -> Err err

succeed : a -> Parser a
succeed x = Parser <| \inp -> Ok (x, inp)

fail : String -> Parser a
fail err = Parser <| \_ -> Err err

map : (a -> b) -> Parser a -> Parser b
map f p = Parser <| \inp ->
  case runParser p inp of
    Ok (x, more) -> Ok (f x, more)
    Err err -> Err err

andThen : Parser a -> (a -> Parser b) -> Parser b
andThen p f = Parser <| \inp ->
  case runParser p inp of
    Ok (x, more) -> runParser (f x) more
    Err err -> Err err

followedBy : Parser a -> Parser b -> Parser b
followedBy p q = p `andThen` (always q)

andMap : Parser (a -> b) -> Parser a -> Parser b
andMap a p = a `andThen` \f -> p `andThen` \a -> succeed (f a)

or : Parser a -> Parser a -> Parser a
or q w = Parser <| \inp ->
  case runParser q inp of
    Ok _ as ok -> ok
    Err _ -> runParser w inp

-- try : Parser a -> Parser a
-- try p = Parser <| \inp ->

errMsgExpected : String -> String -> String
errMsgExpected label inp =
  "expected " ++ label ++ " at or near '" ++ (String.left 5 inp) ++ "'"

end : Parser ()
end = Parser <| \inp ->
  case inp of
    "" -> Ok ((), "")
    _ -> Err <| errMsgExpected "end of input" inp

many : Parser a -> Parser (List a)
many p = (some p) `or` (succeed [])

some : Parser a -> Parser (List a)
some p = p `andThen` \v -> many p `andThen` \vs -> succeed (v :: vs)

skipMany : Parser a -> Parser ()
skipMany p = many p `followedBy` succeed ()

skipSome : Parser a -> Parser ()
skipSome p = some p `followedBy` succeed ()

between : Parser open -> Parser close -> Parser a -> Parser a
between open close p =
  open `andThen` \_ ->
  p `andThen` \x ->
  close `andThen` \_ ->
  succeed x

annotate : Parser a -> String -> Parser a
annotate p label = Parser <| \inp ->
  case runParser p inp of
    Ok _ as ok -> ok
    Err _ -> Err <| errMsgExpected label inp
