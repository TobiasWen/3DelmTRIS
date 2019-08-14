module Grid exposing (Cell, Color, Grid, Position, rgb)

-- The color of a cell


type alias Color =
    { r : Int, g : Int, b : Int }



-- The position of a cell in 3D space


type alias Position =
    { x : Int, y : Int, z : Int }



-- One cell represents a building block of a tetroid


type alias Cell =
    { color : Color
    , position : Position
    }



-- A grid is the composition of many cells


type alias Grid =
    List Cell


rgb : Int -> Int -> Int -> Color
rgb red green blue =
    { r = red, g = green, b = blue }
