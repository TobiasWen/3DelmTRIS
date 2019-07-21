module Model exposing (Model, initialModel)

import Grid exposing (Cell, Color, Grid, Position)



-- Current model and initialModel are only placeholders and will
-- be filled with correct data asap.


type alias Model =
    Grid


cell : Cell
cell =
    { color = { red = 255, green = 255, blue = 255 }
    , position = { x = 1.0, y = 2.0, z = 3.0 }
    }


initialModel : Model
initialModel =
    [ cell ]
