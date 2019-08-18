module Dimensions exposing (WorldDimensions, calculateTopCenter)

import Grid exposing (Position)



-- WorldDimensions represent the dimensions of the playing field. E.g. 7*7*14 cells.


type alias WorldDimensions =
    { width : Int
    , height : Int
    , depth : Int
    }


calculateTopCenter : WorldDimensions -> Position
calculateTopCenter { width, height, depth } =
    Position (width // 2) 0 (depth // 2)
