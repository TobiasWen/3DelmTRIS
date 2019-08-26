module Rotation exposing (Axis(..), canRotate, rotateTetroid)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Grid, Position, addPositions, checkGridOverlap, subtractPositions)
import List
import Matrix3 exposing (Mat3, multiplyVecMatrix)
import Movement exposing (calculateWallKickVector, translateTetroid)
import Tetroids exposing (Tetroid)


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
            { tetroid | grid = List.map (\cell -> { cell | position = addPositions tetroid.center <| multiplyVecMatrix xAxisRotationMatrix <| subtractPositions cell.position tetroid.center }) tetroid.grid }

        Y ->
            { tetroid | grid = List.map (\cell -> { cell | position = addPositions tetroid.center <| multiplyVecMatrix yAxisRotationMatrix <| subtractPositions cell.position tetroid.center }) tetroid.grid }

        Z ->
            { tetroid | grid = List.map (\cell -> { cell | position = addPositions tetroid.center <| multiplyVecMatrix zAxisRotationMatrix <| subtractPositions cell.position tetroid.center }) tetroid.grid }


canRotate : Tetroid -> Grid -> Axis -> WorldDimensions -> Bool
canRotate tetroid grid axis dim =
    let
        rotatedTetroid =
            rotateTetroid tetroid axis
    in
    not <| checkGridOverlap grid <| (translateTetroid rotatedTetroid <| calculateWallKickVector rotatedTetroid dim).grid
