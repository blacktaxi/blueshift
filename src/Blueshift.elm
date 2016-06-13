module Blueshift exposing (..)

{-| A monadic parser combinator library, heavily inspired by Parsec.

@docs Parser

# Basic operations
@docs parse, succeed, fail, map, andThen, followedBy, or, andMap, end, many, some, annotate

# Characters
@docs anyChar, satisfy, char, notChar, string, anyOf, noneOf

-}

import Blueshift.Core as Core
import Blueshift.Char as Char

{-| The Parser type.

A value of type `Parser a` is a parser that knows how to parse an `a` from a string.

To make such a value work, we use the `parse` function, by giving it the parser and
a string to parse:

    integer : Parser Int
    integer = ...

    parseInt : String -> Result String Int
    parseInt s = parse integer s

-}
type alias Parser a = Core.Parser a

{-| Run a parser with given input, returning the result of parse. -}
parse : Parser a -> String -> Result String a
parse = Core.parse

{-| A parser that always succeeds, returning the given value as result. -}
succeed : a -> Parser a
succeed = Core.succeed

{-| A parser that always fail with a given error message. -}
fail : String -> Parser a
fail = Core.fail

{-| Apply a given function to the result of a given parser. -}
map : (a -> b) -> Parser a -> Parser b
map = Core.map

{-| Run a given parsing computation on the result of a successful parser of a given parser. -}
andThen : Parser a -> (a -> Parser b) -> Parser b
andThen = Core.andThen

{-| Run the first parser and then the second parser, returning only the second result
(result of the first parser is discarded.) -}
followedBy : Parser a -> Parser b -> Parser b
followedBy = Core.followedBy

{-| Try running the first parser, returning it's result if it succeeds. If it fails, run the
second parser. -}
or : Parser a -> Parser a -> Parser a
or = Core.or

{-| Combine two parsers by applying the resulting function of the first parser to a resulting
value of the second parser. -}
andMap : Parser (a -> b) -> Parser a -> Parser b
andMap = Core.andMap

{-| A parser that expects the end of input and fails otherwise. -}
end : Parser ()
end = Core.end

{-| Apply a given parser zero or more times, accumulating the results into a list. -}
many : Parser a -> Parser (List a)
many = Core.many

{-| Apply a given parser one or more times, accumulating the results into a list. -}
some : Parser a -> Parser (List a)
some = Core.some

{-| Annotate a parser but returning a given error message whenever the parser fails. -}
annotate : Parser a -> String -> Parser a
annotate = Core.annotate

{-| A parser that expects any character. -}
anyChar : Parser Char
anyChar = Char.anyChar

{-| A parser that expects a character that will satisfy a given predicate. -}
satisfy : (Char -> Bool) -> Parser Char
satisfy = Char.satisfy

{-| A parser that expects a particular character. -}
char : Char -> Parser Char
char = Char.char

{-| A parser that expects any but a particular character. -}
notChar : Char -> Parser Char
notChar = Char.notChar

{-| A parser that expects a particular string. -}
string : String -> Parser String
string = Char.string

{-| A parser that expects any of the particular characters from a given string. -}
anyOf : String -> Parser Char
anyOf = Char.anyOf

{-| A parser that expects any but one of the particular characters from a given string. -}
noneOf : String -> Parser Char
noneOf = Char.noneOf
