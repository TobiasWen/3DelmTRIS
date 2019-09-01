module Messages exposing (Msg(..))

import Browser.Dom exposing (Element)
import Grid exposing (Direction)
import Http
import Input exposing (Key, Mouse)
import Rotation exposing (Axis)
import Score exposing (Score, Scores)
import Tetroids exposing (Tetroid)


type Msg
    = NoOp
    | Start Tetroid
    | Stop
    | Tick
    | UpcomingTetroid Tetroid
    | KeyEvent Key
    | MouseEvent Mouse
    | GetWindowsSize Int Int
    | ScoreResponse (Result Http.Error Scores)
    | SendScore Score
    | NewName String
