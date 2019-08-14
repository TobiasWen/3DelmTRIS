module Model exposing (Model, initialModel)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Cell, Color, Grid, Position)
import Tetroids exposing (Tetroid)



-- Work in Progress Model


type GameState
    = Running
    | Stopped


type alias Model =
    { dimensions : WorldDimensions
    , activeTetroid : Tetroid
    , upcomingTetroid : Tetroid
    , grid : Grid
    , gameState : GameState
    , fastFallDown : Bool
    }


cell : Cell
cell =
    { color = { red = 255, green = 255, blue = 255 }
    , position = { x = 1.0, y = 2.0, z = 3.0 }
    }


initialModel : Model
initialModel =
    [ cell ]
