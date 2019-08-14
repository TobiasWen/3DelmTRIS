module Messages exposing (Msg(..))

import Movement exposing (Direction)
import Rotation exposing (Axis)
import Tetroids exposing (Tetroid)


type Msg
    = NoOp
    | Start Tetroid
    | Stop
    | Tick Float
    | FastFallDown Bool
    | Move Direction
    | Rotate Axis
