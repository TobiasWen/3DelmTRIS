module Rotation exposing (Axis(..), canRotate, rotateTetroid)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Grid, Position, checkGridOverlap, positionArithmetics)
import List
import Movement exposing (calculateWallKickVector, translateTetroid)
import Tetroids exposing (Tetroid)



-- A 3x3 Matrix type consisting of three vec3/positions.


type alias Mat3 =
    ( Position, Position, Position )



-- The axes to rotate a tetroid on.


type Axis
    = X
    | Y
    | Z



{- Rotation matrices to perform a 90 degre rotation on the axes
   in euclidean space.
-}


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



{- Rotates the tetroid on the given axis with helo of
   the corresponding rotation matrices.
-}


rotateTetroid : Tetroid -> Axis -> Tetroid
rotateTetroid tetroid axis =
    case axis of
        X ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix xAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }

        Y ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix yAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }

        Z ->
            { tetroid | grid = List.map (\cell -> { cell | position = positionArithmetics (+) tetroid.center <| multiplyVecMatrix zAxisRotationMatrix <| positionArithmetics (-) cell.position tetroid.center }) tetroid.grid }



-- Checks whether a tetroid is able to rotate on the given axis.


canRotate : Tetroid -> Grid -> Axis -> WorldDimensions -> Bool
canRotate tetroid grid axis dim =
    let
        rotatedTetroid =
            rotateTetroid tetroid axis
    in
    not <| checkGridOverlap grid <| (translateTetroid rotatedTetroid <| calculateWallKickVector rotatedTetroid dim).grid



-- Calculation for multiplying a vector with a 3x3 matrix.


multiplyVecMatrix : Mat3 -> Position -> Position
multiplyVecMatrix ( row0, row1, row2 ) vec =
    { x = (row0.x * vec.x) + (row0.y * vec.y) + (row0.z * vec.z)
    , y = (row1.x * vec.x) + (row1.y * vec.y) + (row1.z * vec.z)
    , z = (row2.x * vec.x) + (row2.y * vec.y) + (row2.z * vec.z)
    }
