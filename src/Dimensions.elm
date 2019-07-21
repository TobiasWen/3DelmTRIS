module Dimensions exposing (WorldDimensions)

-- WorldDimensions represent the dimensions of the playing field. E.g. 7*7*14 cells.


type alias WorldDimensions =
    { width : Int
    , height : Int
    , depth : Int
    }
