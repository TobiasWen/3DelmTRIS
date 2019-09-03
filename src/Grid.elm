module Grid exposing (Cell, Color, Direction(..), Grid, Position, checkGridFallDownCollision, checkGridMovementCollision, checkGridOverlap, clearPlanes, filterOutPlanes, getPlanesToRemove, isPlaneFull, isPositionNextToGrid, mergeGrids, positionArithmetics, reColorGrid)

{- The direction in which a grid can be moved from a top down perspective.
   So movement is only possible on the X and Z axis.
-}


type Direction
    = Up
    | Down
    | Left
    | Right



-- The color of a cell.


type alias Color =
    { r : Int
    , g : Int
    , b : Int
    }



-- The position of a cell in 3D space.


type alias Position =
    { x : Float
    , y : Float
    , z : Float
    }



-- One cell represents a building block of a tetroid.


type alias Cell =
    { color : Color
    , position : Position
    }



-- A grid is the composition of many cells.


type alias Grid =
    List Cell



-- Checks whethere a position matches the position of any cell in a grid.


isPositionInGrid : Grid -> Position -> Bool
isPositionInGrid grid pos =
    List.any (\cell -> cell.position == pos) grid



-- Checks whether a given position is above an element of a given grid.


isPositionAboveGrid : Grid -> Position -> Bool
isPositionAboveGrid grid pos =
    List.any (\cell -> cell.position.y == pos.y + 1 && cell.position.x == pos.x && cell.position.z == pos.z) grid



-- Checks whether a psitition is next to any element of a given grid on the X and Z axis.


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



-- Checks whether a given position condition apllies on two grids.


checkPositionConditionOnGrids : (Grid -> Position -> Bool) -> Grid -> Grid -> Bool
checkPositionConditionOnGrids fn g1 g2 =
    List.any (\cell -> fn g2 cell.position) g1



-- Checks whether two grids are overlapping with eachother.


checkGridOverlap : Grid -> Grid -> Bool
checkGridOverlap g1 g2 =
    checkPositionConditionOnGrids isPositionInGrid g1 g2



-- Checks whether two grids would collide on falldown.


checkGridFallDownCollision : Grid -> Grid -> Bool
checkGridFallDownCollision g1 g2 =
    checkPositionConditionOnGrids isPositionAboveGrid g1 g2



-- Checks Whether a grid would collide with another grid when moving into a specific direction


checkGridMovementCollision : Grid -> Grid -> Direction -> Bool
checkGridMovementCollision g1 g2 dir =
    List.any (\cell -> isPositionNextToGrid g2 cell.position dir) g1



-- Calculates on two vectors by utilizing a given higher order function


positionArithmetics : (Float -> Float -> Float) -> Position -> Position -> Position
positionArithmetics fn p1 p2 =
    { x = fn p1.x p2.x, y = fn p1.y p2.y, z = fn p1.z p2.z }



-- Merges 2 Grids into one.


mergeGrids : Grid -> Grid -> Grid
mergeGrids g1 g2 =
    List.concat [ g1, g2 ]



-- Checks whether a whole plane (one line in normal tetris) is full.


isPlaneFull : Grid -> Int -> Float -> Bool
isPlaneFull grid cellCount level =
    (List.foldl (\_ n -> n + 1) 0 <| List.filter (\cell -> cell.position.y == level) grid) == cellCount



-- Returns a list of plane levels for removal.


getPlanesToRemove : Grid -> Float -> Float -> Int -> List Float
getPlanesToRemove grid level height cellCount =
    if level >= height then
        []

    else if isPlaneFull grid cellCount level then
        level :: getPlanesToRemove grid (level + 1) height cellCount

    else
        getPlanesToRemove grid (level + 1) height cellCount



-- Filters out a certain list of planes from a given grid.


filterOutPlanes : Grid -> List Float -> Grid
filterOutPlanes grid planes =
    case planes of
        plane :: rest ->
            filterOutPlanes (List.filter (\cell -> cell.position.y /= plane) grid) rest

        [] ->
            grid



-- Shifts the remaining grid according to the removed planes to close the gaps.


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



{- Clears any full planes on the grid and returns the cleansed grid as well as the count
   of removed planes.
-}


clearPlanes : Grid -> Int -> Float -> ( Grid, Int )
clearPlanes grid cellCount height =
    let
        planesToRemove =
            getPlanesToRemove grid 0 height cellCount
    in
    ( shiftRemainingGrid (filterOutPlanes grid <| planesToRemove) planesToRemove, List.length <| planesToRemove )



-- Changes the color of each cell in a grid to a given color.


reColorGrid : Color -> Grid -> Grid
reColorGrid color grid =
    List.map (\cell -> { cell | color = color, position = cell.position }) grid
