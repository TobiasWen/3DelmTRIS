module Tetroids exposing (Tetroid, createBlueTetroid, createGreenTetroid, createOrangeTetroid, createPinkTetroid, createYellowTetroid, tetroids)

import Grid exposing (Color, Grid, Position)



-- a tetroid simply can be described as a basic grid which consists of colored cells


type alias Tetroid =
    { grid : Grid
    , center : Position
    }



-- Colors


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


createTetroid : Color -> Position -> List Position -> Tetroid
createTetroid color center positions =
    { grid = List.map (\position -> { color = color, position = position }) positions
    , center = center
    }



{-
   Mixing up initialization style of Position record because elm-format creates 4 lines
   instead of one for such a small data structure.
-}


createBlueTetroid : Tetroid
createBlueTetroid =
    createTetroid blue
        { x = 1, y = 0, z = 0 }
        [ Position 0 0 0
        , Position 1 0 0
        , Position 2 0 0
        , Position 3 0 0
        ]


createYellowTetroid : Tetroid
createYellowTetroid =
    createTetroid yellow
        { x = 0, y = 0, z = 0 }
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
        { x = 0, y = 1, z = 0 }
        [ Position 0 0 0
        , Position 0 1 0
        , Position 0 2 0
        , Position 0 2 1
        ]


createGreenTetroid : Tetroid
createGreenTetroid =
    createTetroid green
        { x = 0, y = 1, z = 0 }
        [ Position 0 0 0
        , Position 0 1 0
        , Position 1 1 0
        , Position 1 2 0
        ]


createPinkTetroid : Tetroid
createPinkTetroid =
    createTetroid pink
        { x = 1, y = 0, z = 0 }
        [ Position 0 0 0
        , Position 1 0 0
        , Position 2 0 0
        , Position 1 1 0
        ]


tetroids : List Tetroid
tetroids =
    [ createBlueTetroid
    , createGreenTetroid
    , createOrangeTetroid
    , createPinkTetroid
    , createYellowTetroid
    ]



-- TOOD: In the following will be placed a collection of pre-defined tetroids which are based on the original tetris game.
