module MovementTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Grid exposing (..)
import Movement exposing (..)
import Test exposing (..)
import TestSetup exposing (..)
import Tetroids exposing (..)


suite : Test
suite =
    describe "Tests regarding movement of positions, cells and grids"
        [ describe "Movement.translate"
            [ test "Translate a position" <|
                \_ ->
                    -- { x = 1, y = 1, z = 1 }
                    position
                        |> translate { x = 2, y = -2, z = 15 }
                        |> Expect.equal { x = 3, y = -1, z = 16 }
            , fuzz3 int int int "Translate 100 random positions" <|
                \x y z ->
                    -- { x = 1, y = 1, z = 1 }
                    position
                        |> translate { x = x, y = y, z = z }
                        |> Expect.equal { x = x + 1, y = y + 1, z = z + 1 }
            ]
        , describe "Movement.translateCell"
            [ test "Translate a cell" <|
                \_ ->
                    translateCell cell { x = 2, y = -2, z = 15 }
                        |> Expect.equal { color = { r = 255, g = 255, b = 255 }, position = { x = 3, y = -1, z = 16 } }
            , fuzz3 int int int "Translate 100 random cells" <|
                \x y z ->
                    translateCell cell { x = x, y = y, z = z }
                        |> Expect.equal { color = { r = 255, g = 255, b = 255 }, position = { x = x + 1, y = y + 1, z = z + 1 } }
            ]
        , describe "Movement.translateTetroid"
            [ test "Translate a Tetroid" <|
                \_ ->
                    translateTetroid setupTetroid { x = 2, y = -2, z = 15 }
                        |> Expect.equal
                            (createTetroid
                                blue
                                { x = 3, y = -2, z = 15 }
                                [ Position 2 -2 15
                                , Position 3 -2 15
                                , Position 4 -2 15
                                , Position 5 -2 15
                                ]
                            )
            ]
        , describe "Movement.moveTetroiodCenterToPosition"
            [ test "Withdraw an offset from the tetroids center position relative to a given position" <|
                \_ ->
                    moveTetroidByOffsetFromPosition { x = 3, y = 0, z = 3 } setupTetroid
                        |> Expect.equal
                            (createTetroid
                                blue
                                { x = 3, y = 0, z = 3 }
                                [ Position 2 0 3
                                , Position 3 0 3
                                , Position 4 0 3
                                , Position 5 0 3
                                ]
                            )
            ]
        , describe "Movement.spawnTetroid"
            [ test "Spawns a blue tetroid at the top center of the world" <|
                \_ ->
                    spawnTetroid createBlueTetroid worldDimensions
                        |> Expect.equal blueTetroidInTopCenter
            , test "Spawns an orange tetroid at the top center of the world" <|
                \_ ->
                    spawnTetroid createOrangeTetroid worldDimensions
                        |> Expect.equal orangeTetroidInTopCenter
            ]
        , describe "Movement.fallDown"
            [ test "Let the tetroid fall down one block" <|
                \_ ->
                    fallDown setupTetroid
                        |> Expect.equal
                            (createTetroid blue
                                { x = 1, y = 1, z = 0 }
                                [ Position 0 1 0
                                , Position 1 1 0
                                , Position 2 1 0
                                , Position 3 1 0
                                ]
                            )
            ]
        ]
