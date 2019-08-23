module Messages exposing (Msg(..))

import Grid exposing (Direction)
import Input exposing (Key)
import Rotation exposing (Axis)
import Tetroids exposing (Tetroid)


type Msg
    = NoOp
    | Start Tetroid
    | Stop
    | Tick
    | UpcomingTetroid Tetroid
    | KeyEvent Key
