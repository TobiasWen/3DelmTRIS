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
        , describe "Grid.isPlaneFull"
            [ test "Check if bottom plane is full" <|
                \_ ->
                    isPlaneFull setupPlanesOneLevel (round <| worldDimensions.width * worldDimensions.depth) (worldDimensions.height - 1)
                        |> Expect.equal True
            ]
        , describe "Grid.getPlanesToRemove"
            [ test "Get the bottom lane" <|
                \_ ->
                    getPlanesToRemove setupPlanesOneLevel 0 worldDimensions.height (round <| worldDimensions.width * worldDimensions.depth)
                        |> Expect.equal [ 13 ]
            ]
        , describe "Grid.filterOutPlanes"
            [ test "Filter out bottom plane" <|
                \_ ->
                    filterOutPlanes setupPlanesOneLevel [ 13 ]
                        |> Expect.equal []
            ]
        , describe "Grid.clearPlanes"
            [ test "Clear one plane from grid" <|
                \_ ->
                    clearPlanes setupPlanesOneLevel (round <| worldDimensions.width * worldDimensions.depth) worldDimensions.height
                        |> Expect.equal ( [], 1 )
            ]
        ]
