module Messages exposing (Msg(..))

import Input exposing (Key)
import Movement exposing (Direction)
import Rotation exposing (Axis)
import Tetroids exposing (Tetroid)


type Msg
    = NoOp
    | Start Tetroid
    | Stop
    | Tick
    | UpcomingTetroid Tetroid
    | KeyEvent Key
