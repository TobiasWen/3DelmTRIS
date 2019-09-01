module Model exposing (GameState(..), Model, getTickRate, initialModel)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Cell, Color, Grid, Position)
import Json.Decode
import Messages exposing (Msg(..))
import Random exposing (..)
import Requests exposing (getScoresCmd)
import Score exposing (Scores, ScoresData(..))
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
    , gameOver : Bool
    , mousePosition : { x : Float, y : Float }
    , windowSize : { width : Int, height : Int }
    , highscores : ScoresData
    , score : Int
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
      , gameOver = False
      , mousePosition = { x = 0, y = 0 }
      , windowSize = { width = 1600, height = 1000 }
      , highscores = Loading
      , score = 0
      }
    , Cmd.batch [ Random.generate Start tetroidGenerator, getScoresCmd ]
    )


getTickRate : Model -> Float
getTickRate model =
    if model.fastFallDown then
        model.tickRateMs / 30

    else
        model.tickRateMs
