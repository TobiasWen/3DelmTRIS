module Messages exposing (Msg(..))

import Http
import Input exposing (Key, Mouse)
import Score exposing (Score, Scores)
import Tetroids exposing (Tetroid)


type Msg
    = Start Tetroid
    | Stop
    | Tick
    | UpcomingTetroid Tetroid
    | KeyEvent Key
    | MouseEvent Mouse
    | GetWindowsSize Int Int
    | ScoreResponse (Result Http.Error Scores)
    | SendScore Score
    | NewName String
