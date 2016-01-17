module Main where

import Task
import Console
import ElmTest exposing (..)

import Examples.Csv as Csv
import Blueshift exposing (..)
import Blueshift.Infix exposing (..)

csvExample : Test
csvExample =
  suite "CSV example" <|
    [ test "should error properly on invalid input" <|
        assertEqual (Err "a better error message?") (Csv.parseCSV "hi")
    ]

infixOps : Test
infixOps =
  suite "Infix operators" <|
    [ test "*>" <|
        assertEqual (Ok 6) (parse (char '5' *> succeed 6) "5")
    ]

consoleTests : Console.IO ()
consoleTests =
  consoleRunner csvExample
  `Console.seq` consoleRunner infixOps

port runner : Signal (Task.Task x ())
port runner = Console.run consoleTests
