module Model exposing (GameState(..), Model, getTickRate, initialModel)

import Dimensions exposing (WorldDimensions)
import Grid exposing (Grid)
import Input exposing (Mouse)
import Messages exposing (Msg(..))
import Random exposing (generate)
import Requests exposing (getScoresCmd)
import Score exposing (ScoresData(..))
import Tetroids exposing (Tetroid, tetroidGenerator)


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
    , mousePosition : Mouse
    , windowSize :
        { width : Int
        , height : Int
        }
    , highscores : ScoresData
    , score : Int
    , playerName : String
    }



-- Standard dimensions of the playing field.


initialWorldDimensions : WorldDimensions
initialWorldDimensions =
    { width = 7
    , height = 14
    , depth = 7
    }



-- Initial model on startup


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
      , playerName = ""
      }
    , Cmd.batch [ Random.generate Start tetroidGenerator, getScoresCmd ]
    )


getTickRate : Model -> Float
getTickRate model =
    if model.fastFallDown then
        model.tickRateMs / 30

    else
        model.tickRateMs
