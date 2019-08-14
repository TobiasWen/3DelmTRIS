module Messages exposing (Msg(..))

import Movement exposing (Direction)
import Rotation exposing (Axis)


type Msg
    = NoOp
    | Start
    | Stop
    | Tick Float
    | FastFallDown Bool
    | Move Direction
    | Rotate Axis
