module Grid exposing (Cell, Color, Direction(..), Grid, Position, addPositions, checkGridFallDownCollision, checkGridMovementCollision, checkGridOverlap, clearPlanes, filterOutPlanes, getPlanesToRemove, isPlaneFull, isPositionNextToGrid, mergeGrids, setPosition, subtractPositions)


type Direction
    = Up
    | Down
    | Left
    | Right



-- The color of a cell


type alias Color =
    { r : Int, g : Int, b : Int }



-- The position of a cell in 3D space


type alias Position =
    { x : Float, y : Float, z : Float }


setPosition : Float -> Float -> Float -> Position -> Position
setPosition x y z vec =
    { vec | x = x, y = y, z = z }



-- One cell represents a building block of a tetroid


type alias Cell =
    { color : Color
    , position : Position
    }



-- A grid i1 the composition of many cells


type alias Grid =
    List Cell


isPositionInGrid : Grid -> Position -> Bool
isPositionInGrid grid pos =
    List.any (\cell -> cell.position == pos) grid


isPositionBelowGrid : Grid -> Position -> Bool
isPositionBelowGrid grid pos =
    List.any (\cell -> cell.position.y == pos.y + 1 && cell.position.x == pos.x && cell.position.z == pos.z) grid


isPositionNextToGrid : Grid -> Position -> Direction -> Bool
isPositionNextToGrid grid pos dir =
    case dir of
        Up ->
            List.any (\cell -> cell.position.y == pos.y && cell.position.x == pos.x && cell.position.z == pos.z + 1) grid

        Down ->
            List.any (\cell -> cell.position.y == pos.y && cell.position.x == pos.x && cell.position.z == pos.z - 1) grid

        Left ->
            List.any (\cell -> cell.position.y == pos.y && cell.position.x == pos.x - 1 && cell.position.z == pos.z) grid

        Right ->
            List.any (\cell -> cell.position.y == pos.y && cell.position.x == pos.x + 1 && cell.position.z == pos.z) grid


checkGridOverlap : Grid -> Grid -> Bool
checkGridOverlap g1 g2 =
    List.any (\cell -> isPositionInGrid g2 cell.position) g1


checkGridFallDownCollision : Grid -> Grid -> Bool
checkGridFallDownCollision g1 g2 =
    List.any (\cell -> isPositionBelowGrid g2 cell.position) g1


checkGridMovementCollision : Grid -> Grid -> Direction -> Bool
checkGridMovementCollision g1 g2 dir =
    List.any (\cell -> isPositionNextToGrid g2 cell.position dir) g1



-- TODO: Optimize with function receiving operator (+) (-) etc.


subtractPositions : Position -> Position -> Position
subtractPositions p1 p2 =
    { p1 | x = p1.x - p2.x, y = p1.y - p2.y, z = p1.z - p2.z }


addPositions : Position -> Position -> Position
addPositions p1 p2 =
    { p1 | x = p1.x + p2.x, y = p1.y + p2.y, z = p1.z + p2.z }



-- Merges 2 Grids into one. Could be extended by some checks


mergeGrids : Grid -> Grid -> Grid
mergeGrids g1 g2 =
    List.concat [ g1, g2 ]


isPlaneFull : Grid -> Int -> Float -> Bool
isPlaneFull grid cellCount level =
    (List.length <| List.filter (\cell -> cell.position.y == level) grid) == cellCount


getPlanesToRemove : Grid -> Float -> Float -> Int -> List Float
getPlanesToRemove grid level height cellCount =
    if level >= height then
        []

    else if isPlaneFull grid cellCount level then
        level :: getPlanesToRemove grid (level + 1) height cellCount

    else
        getPlanesToRemove grid (level + 1) height cellCount


filterOutPlanes : Grid -> List Float -> Grid
filterOutPlanes grid planes =
    case planes of
        plane :: rest ->
            filterOutPlanes (List.filter (\cell -> cell.position.y /= plane) grid) rest

        [] ->
            grid


clearPlanes : Grid -> Int -> Float -> ( Grid, Int )
clearPlanes grid cellCount height =
    ( filterOutPlanes grid <| getPlanesToRemove grid 0 height cellCount, List.length <| getPlanesToRemove grid 0 height cellCount )
