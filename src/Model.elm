module Model exposing (Model, initialModel)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Cell, Color, Grid, Position)
import Tetroids exposing (..)



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


initialWorldDimensions : WorldDimensions
initialWorldDimensions =
    { width = 7
    , height = 14
    , depth = 7
    }


initialModel : Model
initialModel =
    { dimensions = initialWorldDimensions
    , activeTetroid = createBlueTetroid
    , upcomingTetroid = createGreenTetroid
    , grid = []
    , gameState = Running
    , fastFallDown = False
    }
