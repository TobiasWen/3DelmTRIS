module TestSetup exposing (blueTetroidInTopCenter, cell, orangeTetroidInTopCenter, position, setupPlanesOneLevel, setupTetroid, worldDimensions)

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


setupPlanesOneLevel : Grid
setupPlanesOneLevel =
    createFilledGrid (worldDimensions.height - 1) worldDimensions


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


createFilledGrid : Float -> WorldDimensions -> Grid
createFilledGrid level dims =
    let
        createCells : Grid
        createCells =
            List.repeat (round <| dims.width * dims.depth) { color = Color 255 255 255, position = Position 0 0 0 }

        setPlaneCoordinates : Grid -> Grid
        setPlaneCoordinates grid =
            List.indexedMap (\index currentCell -> { currentCell | position = { x = toFloat <| modBy (round dims.width) index, y = level, z = toFloat <| index // round dims.width } }) grid
    in
    setPlaneCoordinates createCells
