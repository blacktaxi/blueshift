module Blueshift where

{-| A monadic parser combinator library, heavily inspired by Parsec.

@docs Parser, parse, succeed, fail, map, andThen, followedBy
@docs or, apply, end, anyChar, satisfy, char, notChar, many, some
@docs annotate, string, anyOf, noneOf

-}

import Blueshift.Core as Impl

{-| The Parser type.

A value of type `Parser a` is a parser that knows how to parse an `a` from a string.

To make such a value work, we use the `parse` function, by giving it the parser and
a string to parse:

    integer : Parser Int
    integer = ...

    parseInt : String -> Result String Int
    parseInt s = parse integer s

-}
type alias Parser a = Impl.Parser a

{-| Run a parser with given input, returning the result of parse. -}
parse : Parser a -> String -> Result String a
parse = Impl.parse

{-| A parser that always succeeds, returning the given value as result. -}
succeed : a -> Parser a
succeed = Impl.succeed

{-| A parser that always fail with a given error message. -}
fail : String -> Parser a
fail = Impl.fail

{-| Apply a given function to the result of a given parser. -}
map : (a -> b) -> Parser a -> Parser b
map = Impl.map

{-| Run a given parsing computation on the result of a successful parser of a given parser. -}
andThen : Parser a -> (a -> Parser b) -> Parser b
andThen = Impl.andThen

{-| Run the first parser and then the second parser, returning only the second result
(result of the first parser is discarded.) -}
followedBy : Parser a -> Parser b -> Parser b
followedBy = Impl.followedBy

{-| Try running the first parser, returning it's result if it succeeds. If it fails, run the
second parser. -}
or : Parser a -> Parser a -> Parser a
or = Impl.or

{-| Combine two parsers by applying the resulting function of the first parser to a resulting
value of the second parser. -}
apply : Parser (a -> b) -> Parser a -> Parser b
apply = Impl.apply

{-| A parser that expects the end of input and fails otherwise. -}
end : Parser ()
end = Impl.end

{-| A parser that expects any character. -}
anyChar : Parser Char
anyChar = Impl.anyChar

{-| A parser that expects a character that will satisfy a given predicate. -}
satisfy : (Char -> Bool) -> Parser Char
satisfy = Impl.satisfy

{-| A parser that expects a particular character. -}
char : Char -> Parser Char
char = Impl.char

{-| A parser that expects any but a particular character. -}
notChar : Char -> Parser Char
notChar = Impl.notChar

{-| Apply a given parser zero or more times, accumulating the results into a list. -}
many : Parser a -> Parser (List a)
many = Impl.many

{-| Apply a given parser one or more times, accumulating the results into a list. -}
some : Parser a -> Parser (List a)
some = Impl.some

{-| Annotate a parser but returning a given error message whenever the parser fails. -}
annotate : Parser a -> String -> Parser a
annotate = Impl.annotate

{-| A parser that expects a particular string. -}
string : String -> Parser String
string = Impl.string

{-| A parser that expects any of the particular characters from a given string. -}
anyOf : String -> Parser Char
anyOf = Impl.anyOf

{-| A parser that expects any but one of the particular characters from a given string. -}
noneOf : String -> Parser Char
noneOf = Impl.noneOf
