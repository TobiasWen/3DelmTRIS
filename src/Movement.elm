module Movement exposing (calculateWallKickVector, fallDown, isCollidingWithFloor, moveTetroid, moveTetroidByOffsetFromPosition, spawnTetroid, translate, translateCell, translateTetroid)

import Dimensions exposing (WorldDimensions, calculateTopCenter)
import Grid exposing (Cell, Direction(..), Grid, Position, positionArithmetics)
import List
import Tetroids exposing (Tetroid)



-- Moves a position by a  given vector.


translate : Position -> Position -> Position
translate origin vec =
    positionArithmetics (+) origin vec



-- Moves a cell by a given vector.


translateCell : Cell -> Position -> Cell
translateCell cell vec =
    { cell | position = translate cell.position vec }



-- Moves a tetroid by a given vector.


translateTetroid : Tetroid -> Position -> Tetroid
translateTetroid { grid, center } vec =
    Tetroid (List.map (\cell -> translateCell cell vec) grid) (translate center vec)



-- Withdraw an offset from the tetroids center position relative to a given position


moveTetroidByOffsetFromPosition : Position -> Tetroid -> Tetroid
moveTetroidByOffsetFromPosition pos { grid, center } =
    let
        offset =
            { x = toFloat <| ceiling <| (center.x - pos.x) * -1
            , y = 0
            , z = toFloat <| ceiling <| (center.z - pos.z) * -1
            }
    in
    Tetroid (List.map (\cell -> translateCell cell offset) grid) (translate center offset)



-- Spawns the tetroid at the center of playing field


spawnTetroid : Tetroid -> WorldDimensions -> Tetroid
spawnTetroid tetroid dimensions =
    let
        topCenter =
            calculateTopCenter dimensions
    in
    translateTetroid tetroid topCenter |> moveTetroidByOffsetFromPosition topCenter



-- Moves the tetroid down by one field.


fallDown : Tetroid -> Tetroid
fallDown tetroid =
    translateTetroid tetroid { x = 0, y = 1, z = 0 }



-- Checks whether a tetroid is colliding with the playing fields floor.


isCollidingWithFloor : Tetroid -> WorldDimensions -> Bool
isCollidingWithFloor tetroid dim =
    List.any (\cell -> cell.position.y >= dim.height - 1) tetroid.grid



{- Calculate the vector by which the tetroid should be moved to fulfil a valid rotation
   despite being next to wall.
-}


calculateWallKickVector : Tetroid -> WorldDimensions -> Position
calculateWallKickVector t dim =
    let
        vectorCounterHelper : Grid -> WorldDimensions -> Position -> Position
        vectorCounterHelper grid dimension vector =
            case grid of
                cell :: rest ->
                    if cell.position.x >= dimension.width then
                        vectorCounterHelper rest dimension { vector | x = vector.x - 1 }

                    else if cell.position.x < 0 then
                        vectorCounterHelper rest dimension { vector | x = vector.x + 1 }

                    else if cell.position.z >= dimension.depth then
                        vectorCounterHelper rest dimension { vector | z = vector.z - 1 }

                    else if cell.position.z < 0 then
                        vectorCounterHelper rest dimension { vector | z = vector.z + 1 }

                    else
                        vectorCounterHelper rest dimension vector

                [] ->
                    vector
    in
    vectorCounterHelper t.grid dim (Position 0 0 0)



-- Moves a tetroid by one into the given direction on X and Z axis.


moveTetroid : Tetroid -> Direction -> WorldDimensions -> Tetroid
moveTetroid tetroid dir dimensions =
    case dir of
        Up ->
            if List.any (\cell -> cell.position.z >= dimensions.depth - 1) tetroid.grid then
                tetroid

            else
                translateTetroid tetroid { x = 0, y = 0, z = 1 }

        Down ->
            if List.any (\cell -> cell.position.z <= 0) tetroid.grid then
                tetroid

            else
                translateTetroid tetroid { x = 0, y = 0, z = -1 }

        Left ->
            if List.any (\cell -> cell.position.x <= 0) tetroid.grid then
                tetroid

            else
                translateTetroid tetroid { x = -1, y = 0, z = 0 }

        Right ->
            if List.any (\cell -> cell.position.x >= dimensions.width - 1) tetroid.grid then
                tetroid

            else
                translateTetroid tetroid { x = 1, y = 0, z = 0 }
