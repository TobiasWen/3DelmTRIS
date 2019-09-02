module Rotation exposing (Axis(..), canRotate, rotateTetroid)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Grid, Position, checkGridOverlap, positionArithmetics)
import List
import Movement exposing (calculateWallKickVector, translateTetroid)
import Tetroids exposing (Tetroid)


type alias Mat3 =
    ( Position, Position, Position )


type Axis
    = X
    | Y
    | Z


xAxisRotationMatrix : Mat3
xAxisRotationMatrix =
    ( Position 1 0 0
    , Position 0 0 -1
    , Position 0 1 0
    )


yAxisRotationMatrix : Mat3
yAxisRotationMatrix =
    ( Position 0 0 1
    , Position 0 1 0
    , Position -1 0 0
    )


zAxisRotationMatrix : Mat3
zAxisRotationMatrix =
    ( Position 0 -1 0
    , Position 1 0 0
    , Position 0 0 1
    )


rotateTetroid : Tetroid -> Axis -> Tetroid
rotateTetroid tetroid axis =
    case axis of
        X ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix xAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }

        Y ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix yAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }

        Z ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix zAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }


canRotate : Tetroid -> Grid -> Axis -> WorldDimensions -> Bool
canRotate tetroid grid axis dim =
    let
        rotatedTetroid =
            rotateTetroid tetroid axis
    in
    not <| checkGridOverlap grid <| (translateTetroid rotatedTetroid <| calculateWallKickVector rotatedTetroid dim).grid


multiplyVecMatrix : Mat3 -> Position -> Position
multiplyVecMatrix ( row0, row1, row2 ) vec =
    { x = (row0.x * vec.x) + (row0.y * vec.y) + (row0.z * vec.z)
    , y = (row1.x * vec.x) + (row1.y * vec.y) + (row1.z * vec.z)
    , z = (row2.x * vec.x) + (row2.y * vec.y) + (row2.z * vec.z)
    }
