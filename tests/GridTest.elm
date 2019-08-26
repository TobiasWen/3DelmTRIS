module GridTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Grid exposing (..)
import Movement exposing (..)
import Test exposing (..)
import TestSetup exposing (..)
import Tetroids exposing (..)


suite : Test
suite =
    describe "Tests regarding Grid module"
        [ describe "Grid.subtractPositions"
            [ test "Subtract two positions" <|
                \_ ->
                    -- { x = 1, y = 1, z = 1 }
                    position
                        |> subtractPositions { x = 0, y = 0, z = 0 }
                        |> Expect.equal { x = -1, y = -1, z = -1 }
            ]
        ]
