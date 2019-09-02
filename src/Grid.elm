module Grid exposing (Cell, Color, Direction(..), Grid, Position, checkGridFallDownCollision, checkGridMovementCollision, checkGridOverlap, clearPlanes, filterOutPlanes, getPlanesToRemove, isPlaneFull, isPositionNextToGrid, mergeGrids, positionArithmetics, reColorGrid)


type Direction
    = Up
    | Down
    | Left
    | Right



-- The color of a cell


type alias Color =
    { r : Int
    , g : Int
    , b : Int
    }



-- The position of a cell in 3D space


type alias Position =
    { x : Float
    , y : Float
    , z : Float
    }



-- One cell represents a building block of a tetroid


type alias Cell =
    { color : Color
    , position : Position
    }



-- A grid is the composition of many cells


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


checkPositionConditionOnGrids : (Grid -> Position -> Bool) -> Grid -> Grid -> Bool
checkPositionConditionOnGrids fn g1 g2 =
    List.any (\cell -> fn g2 cell.position) g1


checkGridOverlap : Grid -> Grid -> Bool
checkGridOverlap g1 g2 =
    checkPositionConditionOnGrids isPositionInGrid g1 g2


checkGridFallDownCollision : Grid -> Grid -> Bool
checkGridFallDownCollision g1 g2 =
    checkPositionConditionOnGrids isPositionBelowGrid g1 g2


checkGridMovementCollision : Grid -> Grid -> Direction -> Bool
checkGridMovementCollision g1 g2 dir =
    List.any (\cell -> isPositionNextToGrid g2 cell.position dir) g1


positionArithmetics : (Float -> Float -> Float) -> Position -> Position -> Position
positionArithmetics fn p1 p2 =
    { x = fn p1.x p2.x, y = fn p1.y p2.y, z = fn p1.z p2.z }



-- Merges 2 Grids into one. Could be extended by some checks


mergeGrids : Grid -> Grid -> Grid
mergeGrids g1 g2 =
    List.concat [ g1, g2 ]


isPlaneFull : Grid -> Int -> Float -> Bool
isPlaneFull grid cellCount level =
    (List.foldl (\_ n -> n + 1) 0 <| List.filter (\cell -> cell.position.y == level) grid) == cellCount


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


shiftRemainingGrid : Grid -> List Float -> Grid
shiftRemainingGrid grid removedPlanes =
    let
        shiftCellByOne : Cell -> Cell
        shiftCellByOne c =
            { color = c.color, position = { x = c.position.x, y = c.position.y + 1, z = c.position.z } }

        shift : List Float -> Grid -> Grid
        shift rP g =
            case rP of
                currentLevel :: rest ->
                    List.filter (\cell -> cell.position.y < currentLevel) g
                        |> List.map shiftCellByOne
                        |> mergeGrids (List.filter (\cell -> cell.position.y > currentLevel) g)
                        |> shift rest

                [] ->
                    g
    in
    shift (removedPlanes |> List.sort) grid


clearPlanes : Grid -> Int -> Float -> ( Grid, Int )
clearPlanes grid cellCount height =
    let
        planesToRemove =
            getPlanesToRemove grid 0 height cellCount
    in
    ( shiftRemainingGrid (filterOutPlanes grid <| planesToRemove) planesToRemove, List.length <| planesToRemove )


reColorGrid : Color -> Grid -> Grid
reColorGrid color grid =
    List.map (\cell -> { cell | color = color, position = cell.position }) grid
