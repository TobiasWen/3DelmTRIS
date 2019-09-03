module Tetroids exposing (Tetroid, blue, createBlueTetroid, createGreenTetroid, createOrangeTetroid, createPinkTetroid, createTetroid, createYellowTetroid, green, orange, pink, tetroidGenerator, tetroids, yellow)

import Grid exposing (Color, Grid, Position)
import Random exposing (Generator, uniform)



{- a tetroid simply can be described as a basic grid which
   consists of colored cells with an additional center position.
-}


type alias Tetroid =
    { grid : Grid
    , center : Position
    }



-- RGB Colors


blue : Color
blue =
    Color 68 255 255


yellow : Color
yellow =
    Color 255 255 68


orange : Color
orange =
    Color 255 136 0


green : Color
green =
    Color 68 255 68


pink : Color
pink =
    Color 255 68 255



-- Tetroid creation


tetroidGenerator : Generator Tetroid
tetroidGenerator =
    case tetroids of
        x :: xs ->
            Random.uniform x xs

        [] ->
            Random.uniform createBlueTetroid []


createTetroid : Color -> Position -> List Position -> Tetroid
createTetroid color center positions =
    { grid = List.map (\position -> { color = color, position = position }) positions
    , center = center
    }



-- Functions to create the tetroids in the well known shapes.


createBlueTetroid : Tetroid
createBlueTetroid =
    createTetroid blue
        (Position 1 0 0)
        [ Position 0 0 0
        , Position 1 0 0
        , Position 2 0 0
        , Position 3 0 0
        ]


createYellowTetroid : Tetroid
createYellowTetroid =
    createTetroid yellow
        (Position 0.5 0.5 0.5)
        [ Position 0 0 0
        , Position 0 1 0
        , Position 1 0 0
        , Position 1 1 0
        , Position 0 0 1
        , Position 0 1 1
        , Position 1 0 1
        , Position 1 1 1
        ]


createOrangeTetroid : Tetroid
createOrangeTetroid =
    createTetroid orange
        (Position 0 1 0)
        [ Position 0 0 0
        , Position 0 1 0
        , Position 0 2 0
        , Position 0 2 1
        ]


createGreenTetroid : Tetroid
createGreenTetroid =
    createTetroid green
        (Position 0 1 0)
        [ Position 0 0 0
        , Position 0 1 0
        , Position 1 1 0
        , Position 1 2 0
        ]


createPinkTetroid : Tetroid
createPinkTetroid =
    createTetroid pink
        (Position 1 0 0)
        [ Position 0 0 0
        , Position 1 0 0
        , Position 2 0 0
        , Position 1 1 0
        ]



-- The pool of available tetroids to randomize from.


tetroids : List Tetroid
tetroids =
    [ createBlueTetroid
    , createGreenTetroid
    , createOrangeTetroid
    , createPinkTetroid
    , createYellowTetroid
    ]
