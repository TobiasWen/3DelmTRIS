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
            [ test "Get the bottom lpane" <|
                \_ ->
                    getPlanesToRemove setupPlanesOneLevel 0 worldDimensions.height (round <| worldDimensions.width * worldDimensions.depth)
                        |> Expect.equal [ 13 ]
            , test "Get the second plane" <|
                \_ ->
                    getPlanesToRemove secondLevelPlaneWithBlocksBelowAndAbove 0 worldDimensions.height (round <| worldDimensions.width * worldDimensions.depth)
                        |> Expect.equal [ 12 ]
            ]
        , describe "Grid.filterOutPlanes"
            [ test "Filter out bottom plane" <|
                \_ ->
                    filterOutPlanes setupPlanesOneLevel [ 13 ]
                        |> Expect.equal []
            , test "Filter out second plane" <|
                \_ ->
                    filterOutPlanes secondLevelPlaneWithBlocksBelowAndAbove [ 12 ]
                        |> Expect.equal
                            [ { color = Color 255 255 255, position = Position 0 13 0 }
                            , { color = Color 0 0 0, position = Position 0 11 0 }
                            ]
            ]
        , describe "Grid.clearPlanes"
            [ test "Clear one plane from grid" <|
                \_ ->
                    clearPlanes setupPlanesOneLevel (round <| worldDimensions.width * worldDimensions.depth) worldDimensions.height
                        |> Expect.equal ( [], 1 )
            , test "Clear four level plane with one additional cell on top which remains after clear." <|
                \_ ->
                    clearPlanes planesFourLevelWithOneAdditionalCell (round <| worldDimensions.width * worldDimensions.depth) worldDimensions.height
                        |> Expect.equal ( [ { color = Color 255 255 255, position = Position 0 13 0 } ], 4 )
            , test "Clear four level plane with thre additional cell on top which are on seperate levels." <|
                \_ ->
                    clearPlanes planesFourLevelWithAdditionalCells (round <| worldDimensions.width * worldDimensions.depth) worldDimensions.height
                        |> Expect.equal
                            ( [ { color = Color 255 255 255, position = Position 0 13 0 }
                              , { color = Color 255 255 255, position = Position 0 12 0 }
                              , { color = Color 255 255 255, position = Position 0 11 0 }
                              ]
                            , 4
                            )
            , test "Clear second level plane with blocks on first plane and additional cell on top." <|
                \_ ->
                    clearPlanes secondLevelPlaneWithBlocksBelowAndAbove (round <| worldDimensions.width * worldDimensions.depth) worldDimensions.height
                        |> Expect.equal
                            ( [ { color = Color 255 255 255, position = Position 0 13 0 }
                              , { color = Color 0 0 0, position = Position 0 12 0 }
                              ]
                            , 1
                            )
            ]
        ]
