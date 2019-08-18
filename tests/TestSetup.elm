module TestSetup exposing (blueTetroidInTopCenter, cell, orangeTetroidInTopCenter, position, setupTetroid, worldDimensions)

import Dimensions exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Grid exposing (..)
import Test exposing (..)
import Tetroids exposing (..)


position : Position
position =
    { x = 1, y = 1, z = 1 }


cell : Cell
cell =
    { color = Color 255 255 255, position = position }


setupTetroid : Tetroid
setupTetroid =
    createTetroid blue
        { x = 1, y = 0, z = 0 }
        [ Position 0 0 0
        , Position 1 0 0
        , Position 2 0 0
        , Position 3 0 0
        ]


worldDimensions : WorldDimensions
worldDimensions =
    { width = 7
    , height = 14
    , depth = 7
    }


blueTetroidInTopCenter : Tetroid
blueTetroidInTopCenter =
    createTetroid blue
        { x = 3, y = 0, z = 3 }
        [ Position 2 0 3
        , Position 3 0 3
        , Position 4 0 3
        , Position 5 0 3
        ]


orangeTetroidInTopCenter : Tetroid
orangeTetroidInTopCenter =
    createTetroid orange
        { x = 3, y = 1, z = 3 }
        [ Position 3 0 3
        , Position 3 1 3
        , Position 3 2 3
        , Position 3 2 4
        ]
