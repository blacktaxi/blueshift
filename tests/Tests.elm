module Main where

import List
import Task

import Console exposing (..)
import ElmTest exposing (..)

import Examples.Csv as Csv

tests : List Test
tests =
  [ 0 `equals` 0
  , test "pass" <| assert True
  , test "fail" <| assertNotEqual True False
  ]
  ++
  (List.map defaultTest <| assertionList [1..10] [1..10])

csvExampleSuite =
  suite "CSV example" <|
    [ test "should error properly on invalid input" <|
        assertEqual (Err "a better error message?") (Csv.parseCSV "hi")
    ]

consoleTests : IO ()
consoleTests =
  consoleRunner csvExampleSuite

port runner : Signal (Task.Task x ())
port runner = Console.run consoleTests
