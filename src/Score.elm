module Score exposing (Score, Scores, ScoresData(..), clearPointsFourPlanes, clearPointsOnePlane, clearPointsThreePlanes, clearPointsTwoPlanes, pointsBlockPlaced, scoreDecoder, scoreListDecoder)

import Http
import Json.Decode


type ScoresData
    = Loaded Scores
    | Loading
    | Error Http.Error


type alias Score =
    { name : String
    , score : Int
    }


type alias Scores =
    { scores : List Score }



{- Score Point constants which are added to the score each time a
   tetroid is placed or a plane is cleared.
-}


clearPointsOnePlane : Int
clearPointsOnePlane =
    1000


clearPointsTwoPlanes : Int
clearPointsTwoPlanes =
    3000


clearPointsThreePlanes : Int
clearPointsThreePlanes =
    5000


clearPointsFourPlanes : Int
clearPointsFourPlanes =
    10000


pointsBlockPlaced : Int
pointsBlockPlaced =
    100



-- ScoreDecoder


scoreDecoder : Json.Decode.Decoder Score
scoreDecoder =
    Json.Decode.map2 (\name score -> { name = name, score = score })
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "score" Json.Decode.int)


scoreListDecoder : Json.Decode.Decoder Scores
scoreListDecoder =
    Json.Decode.map (\scores -> { scores = scores })
        (Json.Decode.field "scores" (Json.Decode.list scoreDecoder))
