module Matrix3 exposing (Mat3, multiplyVecMatrix)

import Grid exposing (Position)


type alias Mat3 =
    ( Position, Position, Position )


multiplyVecMatrix : Mat3 -> Position -> Position
multiplyVecMatrix ( row0, row1, row2 ) vec =
    { x = (row0.x * vec.x) + (row0.y * vec.y) + (row0.z * vec.z)
    , y = (row1.x * vec.x) + (row1.y * vec.y) + (row1.z * vec.z)
    , z = (row2.x * vec.x) + (row2.y * vec.y) + (row2.z * vec.z)
    }
