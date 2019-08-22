module Model exposing (GameState(..), Model, getTickRate, initialModel)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Cell, Color, Grid, Position)
import Json.Decode
import Messages exposing (Msg(..))
import Random exposing (..)
import Tetroids exposing (..)



-- Work in Progress Model


type GameState
    = Running
    | Stopped


type alias Model =
    { dimensions : WorldDimensions
    , activeTetroid : Maybe Tetroid
    , upcomingTetroid : Maybe Tetroid
    , grid : Grid
    , gameState : GameState
    , fastFallDown : Bool
    , tickRateMs : Float
    , counter : Int
    }


initialWorldDimensions : WorldDimensions
initialWorldDimensions =
    { width = 7
    , height = 14
    , depth = 7
    }


initialModel : ( Model, Cmd Msg )
initialModel =
    ( { dimensions = initialWorldDimensions
      , activeTetroid = Nothing
      , upcomingTetroid = Nothing
      , grid = []
      , gameState = Stopped
      , fastFallDown = False
      , tickRateMs = 1000
      , counter = 0
      }
    , Random.generate Start tetroidGenerator
    )


getTickRate : Model -> Float
getTickRate model =
    if model.fastFallDown then
        model.tickRateMs / 10

    else
        model.tickRateMs
