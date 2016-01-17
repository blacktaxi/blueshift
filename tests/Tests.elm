module Main where

import Task
import Console
import ElmTest exposing (..)

import Examples.Csv as Csv
import Blueshift exposing (..)
import Blueshift.Infix exposing (..)

assertParse : Result String a -> Parser a -> String -> Assertion
assertParse r p input = assertEqual r (parse p input)

csvExample : Test
csvExample =
  suite "CSV example" <|
    [ test "should error properly on invalid input" <|
        assertEqual (Err "a better error message?") (Csv.parseCSV "hi")
    ]

primitives : Test
primitives =
  suite "Primitive operations" <|
    [ test "succeed" <| assertParse (Ok "ok") (succeed "ok") "test"
    , test "fail" <| assertParse (Err "fayl") (fail "fayl") "test"
    , test "map" <| assertParse (Ok "yay") (succeed "ok" |> map (always "yay")) "test"
    ]

infixOps : Test
infixOps =
  suite "Infix operators" <|
    [ test "*>" <| assertParse (Ok '2') (char '1' *> char '2') "12"
    ]

consoleTests : Console.IO ()
consoleTests =
  consoleRunner <|
    suite "All" <|
      [ primitives
      , infixOps
      , csvExample
      ]

port runner : Signal (Task.Task x ())
port runner = Console.run consoleTests
