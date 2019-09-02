module Dimensions exposing (WorldDimensions, calculateTopCenter)

import Grid exposing (Position)



-- WorldDimensions represent the dimensions of the playing field. E.g. 7*7*14 cells.


type alias WorldDimensions =
    { width : Float
    , height : Float
    , depth : Float
    }


calculateTopCenter : WorldDimensions -> Position
calculateTopCenter { width, depth } =
    Position (toFloat <| floor <| (width / 2)) 0 (toFloat <| floor <| (depth / 2))
