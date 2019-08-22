module Movement exposing (Direction(..), fallDown, moveTetroidByOffsetFromPosition, spawnTetroid, translate, translateCell, translateTetroid)

import Dimensions exposing (WorldDimensions, calculateTopCenter)
import Grid exposing (Cell, Position)
import Tetroids exposing (Tetroid)


type Direction
    = Up
    | Down
    | Left
    | Right


translate : Position -> Position -> Position
translate origin vec =
    { origin | x = origin.x + vec.x, y = origin.y + vec.y, z = origin.z + vec.z }


translateCell : Cell -> Position -> Cell
translateCell cell vec =
    { cell | position = translate cell.position vec }


translateTetroid : Tetroid -> Position -> Tetroid
translateTetroid { grid, center } vec =
    Tetroid (List.map (\cell -> translateCell cell vec) grid) (translate center vec)



-- TODO: Find a better name for this function which describes it accurately or
-- change it when it can't be described.


moveTetroidByOffsetFromPosition : Position -> Tetroid -> Tetroid
moveTetroidByOffsetFromPosition pos { grid, center } =
    let
        offset =
            { x = (center.x - pos.x) * -1
            , y = 0
            , z = (center.z - pos.z) * -1
            }
    in
    Tetroid (List.map (\cell -> translateCell cell offset) grid) (translate center offset)


spawnTetroid : Tetroid -> WorldDimensions -> Tetroid
spawnTetroid tetroid dimensions =
    let
        topCenter =
            calculateTopCenter dimensions
    in
    translateTetroid tetroid topCenter |> moveTetroidByOffsetFromPosition topCenter


fallDown : Tetroid -> Tetroid
fallDown tetroid =
    translateTetroid tetroid { x = 0, y = 1, z = 0 }
